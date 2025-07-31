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
      print('❌ Empty user ID provided to loadCart');
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      print('🛒 CartProvider: Loading cart for user $userId');
      _cartItems = await CartService.getUserCart(userId);
      _calculateSummary();
      print('✅ CartProvider: Cart loaded successfully with ${_cartItems.length} items');
    } catch (e) {
      _error = 'خطأ في تحميل السلة: $e';
      print('❌ CartProvider: Error loading cart: $e');
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
      notifyListeners();
      return false;
    }

    try {
      print('🛒 CartProvider: Adding ${product.arabicName} to cart');
      print('🛒 Product price: ${product.price}');

      // التحقق من صحة سعر المنتج
      if (product.price <= 0) {
        _error = 'سعر المنتج غير صالح';
        notifyListeners();
        return false;
      }

      final cartItem = CartItem(
        objectId: '',
        userId: userId,
        productId: product.objectId,
        product: product,
        quantity: quantity,
        selectedColor: selectedColor,
        addedFrom: addedFrom,
        addedAt: DateTime.now(),
        unitPrice: product.price, // إضافة السعر من المنتج
      );

      final result = await CartService.addToCart(cartItem);
      if (result != null) {
        // إعادة تحميل السلة للحصول على البيانات المحدثة
        await loadCart(userId);
        print('✅ CartProvider: Product added successfully');
        return true;
      } else {
        _error = 'فشل في إضافة المنتج للسلة';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطأ في إضافة المنتج للسلة: $e';
      print('❌ CartProvider: Error adding to cart: $e');
      notifyListeners();
      return false;
    }
  }

  // Update item quantity - مُحسن
  Future<bool> updateQuantity(String userId, String cartItemId, int newQuantity) async {
    try {
      print('🛒 CartProvider: Updating quantity for item $cartItemId to $newQuantity');

      final success = await CartService.updateCartItemQuantity(cartItemId, newQuantity);
      if (success) {
        await loadCart(userId); // إعادة تحميل السلة
        print('✅ CartProvider: Quantity updated successfully');
        return true;
      } else {
        _error = 'فشل في تحديث الكمية';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطأ في تحديث الكمية: $e';
      print('❌ CartProvider: Error updating quantity: $e');
      notifyListeners();
      return false;
    }
  }

  // Remove item from cart - مُحسن
  Future<bool> removeFromCart(String userId, String cartItemId) async {
    try {
      print('🛒 CartProvider: Removing item $cartItemId');

      final success = await CartService.removeFromCart(cartItemId);
      if (success) {
        await loadCart(userId); // إعادة تحميل السلة
        print('✅ CartProvider: Item removed successfully');
        return true;
      } else {
        _error = 'فشل في حذف المنتج';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطأ في حذف المنتج: $e';
      print('❌ CartProvider: Error removing from cart: $e');
      notifyListeners();
      return false;
    }
  }

  // Clear entire cart - مُحسن
  Future<bool> clearCart(String userId) async {
    try {
      print('🛒 CartProvider: Clearing cart for user $userId');

      final success = await CartService.clearCart(userId);
      if (success) {
        _cartItems.clear();
        _calculateSummary();
        print('✅ CartProvider: Cart cleared successfully');
        return true;
      } else {
        _error = 'فشل في إفراغ السلة';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'خطأ في إفراغ السلة: $e';
      print('❌ CartProvider: Error clearing cart: $e');
      notifyListeners();
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

  // Calculate cart summary - مُحسن
  void _calculateSummary() {
    _totalAmount = 0.0;
    _totalItems = 0;
    _uniqueItemsCount = _cartItems.length;

    for (var item in _cartItems) {
      final itemTotal = item.totalPrice;
      _totalAmount += itemTotal;
      _totalItems += item.quantity;

      // طباعة للتشخيص
      print('Item: ${item.product?.arabicName} - Unit: ${item.unitPrice} - Qty: ${item.quantity} - Total: $itemTotal');
    }

    print('🛒 Cart summary calculated: $_totalItems items, ${_totalAmount.toStringAsFixed(0)} ر.س');
    notifyListeners();
  }

  // Validate cart before checkout
  bool validateCart() {
    if (_cartItems.isEmpty) {
      _error = 'السلة فارغة';
      notifyListeners();
      return false;
    }

    // Check if all products are still in stock
    for (var item in _cartItems) {
      if (item.product?.isOutOfStock == true) {
        _error = 'المنتج ${item.product?.arabicName} غير متوفر حالياً';
        notifyListeners();
        return false;
      }

      // التحقق من صحة السعر
      if (item.unitPrice <= 0) {
        _error = 'سعر المنتج ${item.product?.arabicName} غير صالح';
        notifyListeners();
        return false;
      }
    }

    return true;
  }

  // Private helper methods - مُحسن
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Force refresh cart - جديد
  Future<void> refreshCart(String userId) async {
    print('🛒 CartProvider: Force refreshing cart');
    await loadCart(userId);
  }
}