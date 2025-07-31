// lib/data/services/cart_service.dart - مُصلح
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/cart_model.dart';
import 'back4app_service.dart';
import '../../core/constants/app_constants.dart';

class CartService {
  // Get user's cart items - مُحسن
  static Future<List<CartItem>> getUserCart(String userId) async {
    try {
      print('🛒 Loading cart for user: $userId');

      if (userId.isEmpty || userId == 'temp_user_id') {
        print('❌ Invalid userId: $userId');
        return [];
      }

      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);

      // التأكد من تحميل بيانات المنتج بشكل صحيح
      query.includeObject(['product']);
      query.includeObject(['product.category']); // إضافة منفصلة للتأكد

      query.orderByDescending('addedAt');

      final results = await Back4AppService.queryWithConditions(query);

      print('🛒 Raw results count: ${results.length}');

      final cartItems = <CartItem>[];
      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        try {
          print('🛒 Processing cart item ${i + 1}:');
          print('  Raw data keys: ${result.toJson().keys.toList()}');

          final cartItem = CartItem.fromJson(result.toJson());
          cartItems.add(cartItem);

          print('  ✅ Successfully parsed item: ${cartItem.product?.arabicName ?? 'Unknown'}');
        } catch (e) {
          print('❌ Error parsing cart item ${i + 1}: $e');
          print('Raw data: ${result.toJson()}');
          continue;
        }
      }

      print('✅ Successfully parsed ${cartItems.length} cart items');
      return cartItems;
    } catch (e) {
      print('❌ Error getting user cart: $e');
      return [];
    }
  }
  // Add item to cart - مُحسن
  static Future<String?> addToCart(CartItem cartItem) async {
    try {
      print('🛒 Adding to cart: ${cartItem.product?.arabicName} - Price: ${cartItem.unitPrice}');

      // التحقق من صحة البيانات قبل الإضافة
      if (cartItem.unitPrice <= 0) {
        print('❌ Invalid price: ${cartItem.unitPrice}');
        throw Exception('سعر المنتج غير صالح');
      }

      // Check if item already exists
      final existingItem = await getCartItem(
          cartItem.userId,
          cartItem.productId,
          cartItem.selectedColor
      );

      if (existingItem != null) {
        print('🛒 Item exists, updating quantity');
        // Update quantity
        final newQuantity = existingItem.quantity + cartItem.quantity;
        final updated = await updateCartItemQuantity(existingItem.objectId, newQuantity);
        return updated ? existingItem.objectId : null;
      } else {
        print('🛒 Adding new item to cart');
        // Add new item
        final data = cartItem.toJson();

        // التأكد من وجود السعر في البيانات
        if (!data.containsKey('unitPrice') || data['unitPrice'] <= 0) {
          print('❌ Missing or invalid unitPrice in data');
          throw Exception('خطأ في حفظ سعر المنتج');
        }

        final result = await Back4AppService.create(AppConstants.cartTable, data);
        print('✅ Cart item added with ID: $result');
        return result;
      }
    } catch (e) {
      print('❌ Error adding to cart: $e');
      return null;
    }
  }

  // Get specific cart item - مُحسن
  static Future<CartItem?> getCartItem(String userId, String productId, String color) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.whereEqualTo('product', ParseObject(AppConstants.productsTable)..objectId = productId);

      // إضافة فلتر اللون فقط إذا كان موجود
      if (color.isNotEmpty) {
        query.whereEqualTo('selectedColor', color);
      }

      query.includeObject(['product', 'product.category']);

      final results = await Back4AppService.queryWithConditions(query);
      if (results.isNotEmpty) {
        return CartItem.fromJson(results.first.toJson());
      }
      return null;
    } catch (e) {
      print('❌ Error getting cart item: $e');
      return null;
    }
  }

  // Update cart item quantity - مُحسن
  static Future<bool> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      print('🛒 Updating cart item $cartItemId quantity to $quantity');

      if (quantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      final success = await Back4AppService.update(AppConstants.cartTable, cartItemId, {
        'quantity': quantity,
      });

      print(success ? '✅ Quantity updated' : '❌ Failed to update quantity');
      return success;
    } catch (e) {
      print('❌ Error updating cart item quantity: $e');
      return false;
    }
  }

  // Remove item from cart - مُحسن
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      print('🛒 Removing cart item: $cartItemId');
      final success = await Back4AppService.delete(AppConstants.cartTable, cartItemId);
      print(success ? '✅ Item removed' : '❌ Failed to remove item');
      return success;
    } catch (e) {
      print('❌ Error removing from cart: $e');
      return false;
    }
  }

  // Clear user's cart - مُحسن
  static Future<bool> clearCart(String userId) async {
    try {
      print('🛒 Clearing cart for user: $userId');
      final cartItems = await getUserCart(userId);

      bool allSuccess = true;
      for (var item in cartItems) {
        final success = await removeFromCart(item.objectId);
        if (!success) allSuccess = false;
      }

      print(allSuccess ? '✅ Cart cleared' : '⚠️ Some items failed to remove');
      return allSuccess;
    } catch (e) {
      print('❌ Error clearing cart: $e');
      return false;
    }
  }

  // Get cart summary - مُحسن
  static Future<Map<String, dynamic>> getCartSummary(String userId) async {
    try {
      final cartItems = await getUserCart(userId);

      double totalAmount = 0.0;
      int totalItems = 0;

      for (var item in cartItems) {
        totalAmount += item.totalPrice;
        totalItems += item.quantity;
      }

      print('🛒 Cart summary: $totalItems items, ${totalAmount.toStringAsFixed(0)} ر.س');

      return {
        'totalAmount': totalAmount,
        'totalItems': totalItems,
        'itemsCount': cartItems.length,
      };
    } catch (e) {
      print('❌ Error getting cart summary: $e');
      return {
        'totalAmount': 0.0,
        'totalItems': 0,
        'itemsCount': 0,
      };
    }
  }
}