// lib/data/services/cart_service.dart - مُصلح
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/cart_model.dart';
import 'back4app_service.dart';
import '../../core/constants/app_constants.dart';

class CartService {
  // Get user's cart items - مُصلح لحل مشكلة عدم ظهور المنتجات
  static Future<List<CartItem>> getUserCart(String userId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);

      // تضمين تفاصيل المنتج والفئة بشكل صحيح
      query.includeObject(['product', 'product.category']);
      query.orderByDescending('addedAt');

      final results = await Back4AppService.queryWithConditions(query);

      final cartItems = <CartItem>[];

      for (final result in results) {
        try {
          final cartItem = CartItem.fromJson(result.toJson());

          // التأكد من وجود المنتج وصحة البيانات
          if (cartItem.product != null && cartItem.product!.price > 0) {
            cartItems.add(cartItem);
          } else {
            print('⚠️ Cart item has missing or invalid product data: ${cartItem.objectId}');
            // يمكن حذف العنصر التالف من السلة
            await removeFromCart(cartItem.objectId);
          }
        } catch (e) {
          print('❌ Error parsing cart item: $e');
          continue;
        }
      }

      return cartItems;
    } catch (e) {
      print('❌ Error getting user cart: $e');
      return [];
    }
  }

  // Add item to cart - مُحسن
  static Future<String?> addToCart(CartItem cartItem) async {
    try {
      // التحقق من صحة بيانات المنتج قبل الإضافة
      if (cartItem.product == null || cartItem.product!.price <= 0) {
        print('❌ Cannot add cart item: Invalid product data');
        return null;
      }

      // Check if item already exists
      final existingItem = await getCartItem(
          cartItem.userId,
          cartItem.productId,
          cartItem.selectedColor
      );

      if (existingItem != null) {
        // Update quantity
        final newQuantity = existingItem.quantity + cartItem.quantity;
        final updated = await updateCartItemQuantity(existingItem.objectId, newQuantity);
        return updated ? existingItem.objectId : null;
      } else {
        // Add new item
        final data = cartItem.toJson();
        final result = await Back4AppService.create(AppConstants.cartTable, data);

        if (result != null) {
          print('✅ Cart item added successfully: $result');
        }

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

      // تحسين البحث بالألوان
      if (color.isNotEmpty) {
        query.whereEqualTo('selectedColor', color);
      }

      // تضمين تفاصيل المنتج
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

  // Update cart item quantity
  static Future<bool> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      if (quantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      final updated = await Back4AppService.update(AppConstants.cartTable, cartItemId, {
        'quantity': quantity,
        'updatedAt': {'__type': 'Date', 'iso': DateTime.now().toIso8601String()},
      });

      if (updated) {
        print('✅ Cart item quantity updated: $cartItemId -> $quantity');
      }

      return updated;
    } catch (e) {
      print('❌ Error updating cart item quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      final result = await Back4AppService.delete(AppConstants.cartTable, cartItemId);

      if (result) {
        print('✅ Cart item removed: $cartItemId');
      }

      return result;
    } catch (e) {
      print('❌ Error removing from cart: $e');
      return false;
    }
  }

  // Clear user's cart
  static Future<bool> clearCart(String userId) async {
    try {
      final cartItems = await getUserCart(userId);

      bool allCleared = true;
      for (var item in cartItems) {
        final removed = await removeFromCart(item.objectId);
        if (!removed) {
          allCleared = false;
        }
      }

      if (allCleared) {
        print('✅ Cart cleared for user: $userId');
      }

      return allCleared;
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
        if (item.product != null && item.product!.price > 0) {
          totalAmount += item.totalPrice;
          totalItems += item.quantity;
        }
      }

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

  // تنظيف السلة من العناصر التالفة
  static Future<void> cleanupCart(String userId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);

      final results = await Back4AppService.queryWithConditions(query);

      for (final result in results) {
        try {
          final cartItem = CartItem.fromJson(result.toJson());

          // حذف العناصر التي لا تحتوي على منتج صحيح
          if (cartItem.product == null || cartItem.product!.price <= 0) {
            await removeFromCart(cartItem.objectId);
            print('🗑️ Removed invalid cart item: ${cartItem.objectId}');
          }
        } catch (e) {
          // حذف العناصر التي لا يمكن تحليلها
          await Back4AppService.delete(AppConstants.cartTable, result.objectId!);
          print('🗑️ Removed corrupted cart item: ${result.objectId}');
        }
      }
    } catch (e) {
      print('❌ Error cleaning up cart: $e');
    }
  }
}