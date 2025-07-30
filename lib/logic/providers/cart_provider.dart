// lib/logic/providers/cart_provider.dart - مُصلح
import 'package:flutter/material.dart';

import '../../data/models/cart_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  // Cart State
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _error;

  // Cart Summary
  double _totalAmount = 0.0;
  int _totalItems = 0;
  int _uniqueItemsCount = 0;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalAmount => _totalAmount;
  int get totalItems => _totalItems;
  int get uniqueItemsCount => _uniqueItemsCount;
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  String get totalAmountText => '${_totalAmount.toStringAsFixed(0)} ر.س';

  // Load user's cart - مُحسن
  Future<void> loadCart(String userId) async {
    if (userId.isEmpty) {
      print('⚠️ Cannot load cart: userId is empty');
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      print('🛒 Loading cart for user: $userId');

      // تنظيف السلة من العناصر التالفة أولاً
      await CartService.cleanupCart(userId);

      _cartItems = await CartService.getUserCart(userId);
      _calculateSummary();

      print('✅ Cart loaded: ${_cartItems.length} items, Total: ${_totalAmount} ر.س');
    } catch (e) {
      _error = 'خطأ في تحميل السلة: $e';
      print('❌ Error loading cart: $e');
    }

    _setLoading(false);
  }

  // Add product to cart - مُحسن
  Future<bool> addToCart(
      String userId,
      Product product,
      String selectedColor, {
        int quantity = 1,
        String addedFrom = 'browse',
      }) async {
    if (userId.isEmpty) {
      _error = 'يجب تسجيل الدخول أولاً';
      _safeNotifyListeners();
      return false;
    }

    if (product.price <= 0) {
      _error = 'سعر المنتج غير صحيح';
      _safeNotifyListeners();
      return false;
    }

    try {
      print('🛒 Adding to cart: ${product.arabicName} - ${product.price} ر.س');

      final cartItem = CartItem(
        objectId: '',
        userId: userId,
        productId: product.objectId,
        product: product,
        quantity: quantity,
        selectedColor: selectedColor,
        addedFrom: addedFrom,
        addedAt: DateTime.now(),
      );

      final result = await CartService.addToCart(cartItem);
      if (result != null) {
        await loadCart(userId); // Refresh cart
        print('✅ Product added to cart successfully');
        return true;
      } else {
        _error = 'فشل في إضافة المنتج للسلة';
        _safeNotifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطأ في إضافة المنتج للسلة: $e';
      print('❌ Error adding to cart: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  // Update item quantity - مُحسن
  Future<bool> updateQuantity(String userId, String cartItemId, int newQuantity) async {
    try {
      print('🔄 Updating quantity: $cartItemId -> $newQuantity');

      final success = await CartService.updateCartItemQuantity(cartItemId, newQuantity);
      if (success) {
        await loadCart(userId); // Refresh cart
        print('✅ Quantity updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      _error = 'خطأ في تحديث الكمية: $e';
      print('❌ Error updating quantity: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  // Remove item from cart - مُحسن
  Future<bool> removeFromCart(String userId, String cartItemId) async {
    try {
      print('🗑️ Removing from cart: $cartItemId');

      final success = await CartService.removeFromCart(cartItemId);
      if (success) {
        await loadCart(userId); // Refresh cart
        print('✅ Item removed successfully');
        return true;
      }
      return false;
    } catch (e) {
      _error = 'خطأ في حذف المنتج: $e';
      print('❌ Error removing from cart: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  // Clear entire cart - مُحسن
  Future<bool> clearCart(String userId) async {
    try {
      print('🗑️ Clearing cart for user: $userId');

      final success = await CartService.clearCart(userId);
      if (success) {
        _cartItems.clear();
        _calculateSummary();
        print('✅ Cart cleared successfully');
        return true;
      }
      return false;
    } catch (e) {
      _error = 'خطأ في إفراغ السلة: $e';
      print('❌ Error clearing cart: $e');
      _safeNotifyListeners();
      return false;
    }
  }

  // Check if product is in cart
  bool isProductInCart(String productId, String color) {
    return _cartItems.any((item) =>
    item.productId == productId && item.selectedColor == color);
  }

  // Get cart item for specific product and color
  CartItem? getCartItem(String productId, String color) {
    try {
      return _cartItems.firstWhere((item) =>
      item.productId == productId && item.selectedColor == color);
    } catch (e) {
      return null;
    }
  }

  // Get total quantity for a specific product
  int getProductQuantityInCart(String productId) {
    return _cartItems
        .where((item) => item.productId == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Calculate cart summary - مُحسن لحل مشكلة السعر صفر
  void _calculateSummary() {
    _totalAmount = 0.0;
    _totalItems = 0;
    _uniqueItemsCount = _cartItems.length;

    for (var item in _cartItems) {
      if (item.product != null && item.product!.price > 0) {
        final itemTotal = item.product!.price * item.quantity;
        _totalAmount += itemTotal;
        _totalItems += item.quantity;

        print('📊 Item: ${item.product!.arabicName} - ${item.quantity}x${item.product!.price} = ${itemTotal}');
      } else {
        print('⚠️ Invalid cart item found: ${item.objectId}');
      }
    }

    print('📊 Cart Summary: ${_totalItems} items, Total: ${_totalAmount} ر.س');
    _safeNotifyListeners();
  }

  // Validate cart before checkout
  bool validateCart() {
    if (_cartItems.isEmpty) {
      _error = 'السلة فارغة';
      _safeNotifyListeners();
      return false;
    }

    // Check if all products are still in stock and have valid prices
    for (var item in _cartItems) {
      if (item.product?.isOutOfStock == true) {
        _error = 'المنتج ${item.product?.arabicName} غير متوفر حالياً';
        _safeNotifyListeners();
        return false;
      }

      if (item.product == null || item.product!.price <= 0) {
        _error = 'يوجد منتج بسعر غير صحيح في السلة';
        _safeNotifyListeners();
        return false;
      }
    }

    return true;
  }

  // Private helper methods - مُحسن لتجنب مشاكل البناء
  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    // Use post frame callback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearError() {
    _error = null;
    _safeNotifyListeners();
  }

  // إضافة دالة للتحقق من صحة السلة وإصلاحها
  Future<void> validateAndFixCart(String userId) async {
    if (userId.isEmpty) return;

    try {
      bool needsRefresh = false;

      for (var item in List.from(_cartItems)) {
        if (item.product == null || item.product!.price <= 0) {
          await removeFromCart(userId, item.objectId);
          needsRefresh = true;
        }
      }

      if (needsRefresh) {
        await loadCart(userId);
      }
    } catch (e) {
      print('❌ Error validating cart: $e');
    }
  }
}