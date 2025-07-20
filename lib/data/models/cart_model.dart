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
    return CartItem(
      objectId: json['objectId'] ?? '',
      userId: json['user']?['objectId'] ?? '',
      productId: json['product']?['objectId'] ?? '',
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'] ?? '',
      addedFrom: json['addedFrom'] ?? 'browse',
      addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
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
