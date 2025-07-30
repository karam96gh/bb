// lib/data/models/cart_model.dart
import 'package:beauty/data/models/product_model.dart';

class CartItem {
  final String objectId;
  final String userId;
  final String productId;
  final Product? product;
  final int quantity;
  final String selectedColor;
  final String addedFrom;
  final DateTime addedAt;

  CartItem({
    required this.objectId,
    required this.userId,
    required this.productId,
    this.product,
    required this.quantity,
    required this.selectedColor,
    required this.addedFrom,
    required this.addedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Helper function to extract user ID
    String extractUserId(dynamic userField) {
      if (userField is String) {
        return userField;
      } else if (userField is Map<String, dynamic>) {
        return userField['objectId'] ?? '';
      }
      return '';
    }

    // Helper function to extract product ID
    String extractProductId(dynamic productField) {
      if (productField is String) {
        return productField;
      } else if (productField is Map<String, dynamic>) {
        return productField['objectId'] ?? '';
      }
      return '';
    }

    // Helper function to extract product object
    Product? extractProduct(dynamic productField) {
      if (productField is Map<String, dynamic> && productField.containsKey('objectId')) {
        try {
          return Product.fromJson(productField);
        } catch (e) {
          print('❌ Error parsing product: $e');
          return null;
        }
      }
      return null;
    }

    // Helper function to parse date
    DateTime parseDate(dynamic dateField) {
      if (dateField is String) {
        return DateTime.tryParse(dateField) ?? DateTime.now();
      } else if (dateField is Map<String, dynamic> && dateField['iso'] != null) {
        return DateTime.tryParse(dateField['iso']) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return CartItem(
      objectId: json['objectId'] ?? '',
      userId: extractUserId(json['user']),
      productId: extractProductId(json['product']),
      product: extractProduct(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'] ?? '',
      addedFrom: json['addedFrom'] ?? 'browse',
      addedAt: parseDate(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'__type': 'Pointer', 'className': '_User', 'objectId': userId},
      'product': {'__type': 'Pointer', 'className': 'Products', 'objectId': productId},
      'quantity': quantity,
      'selectedColor': selectedColor,
      'addedFrom': addedFrom,
      'addedAt': {'__type': 'Date', 'iso': addedAt.toIso8601String()},
    };
  }

  // Helper methods
  double get totalPrice => product != null ? product!.price * quantity : 0.0;
  String get displayTotalPrice => '${totalPrice.toStringAsFixed(0)} ر.س';

  CartItem copyWith({
    String? objectId,
    int? quantity,
    String? selectedColor,
  }) {
    return CartItem(
      objectId: objectId ?? this.objectId,
      userId: userId,
      productId: productId,
      product: product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      addedFrom: addedFrom,
      addedAt: addedAt,
    );
  }
}