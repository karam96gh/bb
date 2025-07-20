
// lib/data/services/cart_service.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/cart_model.dart';
import 'back4app_service.dart';
import '../../core/constants/app_constants.dart';

class CartService {
  // Get user's cart items
  static Future<List<CartItem>> getUserCart(String userId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.includeObject(['product', 'product.category']);
      query.orderByDescending('addedAt');

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => CartItem.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting user cart: $e');
      return [];
    }
  }

  // Add item to cart
  static Future<String?> addToCart(CartItem cartItem) async {
    try {
      // Check if item already exists
      final existingItem = await getCartItem(cartItem.userId, cartItem.productId, cartItem.selectedColor);

      if (existingItem != null) {
        // Update quantity
        final newQuantity = existingItem.quantity + cartItem.quantity;
        final updated = await updateCartItemQuantity(existingItem.objectId, newQuantity);
        return updated ? existingItem.objectId : null;
      } else {
        // Add new item
        final data = cartItem.toJson();
        return await Back4AppService.create(AppConstants.cartTable, data);
      }
    } catch (e) {
      print('❌ Error adding to cart: $e');
      return null;
    }
  }

  // Get specific cart item
  static Future<CartItem?> getCartItem(String userId, String productId, String color) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.cartTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.whereEqualTo('product', ParseObject(AppConstants.productsTable)..objectId = productId);
      query.whereEqualTo('selectedColor', color);

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

      return await Back4AppService.update(AppConstants.cartTable, cartItemId, {
        'quantity': quantity,
      });
    } catch (e) {
      print('❌ Error updating cart item quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      return await Back4AppService.delete(AppConstants.cartTable, cartItemId);
    } catch (e) {
      print('❌ Error removing from cart: $e');
      return false;
    }
  }

  // Clear user's cart
  static Future<bool> clearCart(String userId) async {
    try {
      final cartItems = await getUserCart(userId);

      for (var item in cartItems) {
        await removeFromCart(item.objectId);
      }

      return true;
    } catch (e) {
      print('❌ Error clearing cart: $e');
      return false;
    }
  }

  // Get cart summary
  static Future<Map<String, dynamic>> getCartSummary(String userId) async {
    try {
      final cartItems = await getUserCart(userId);

      double totalAmount = 0.0;
      int totalItems = 0;

      for (var item in cartItems) {
        totalAmount += item.totalPrice;
        totalItems += item.quantity;
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
}
