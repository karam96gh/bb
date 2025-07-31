// lib/data/models/cart_model.dart - مُصلح
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
  final double unitPrice; // إضافة السعر المحفوظ

  CartItem({
    required this.objectId,
    required this.userId,
    required this.productId,
    this.product,
    required this.quantity,
    required this.selectedColor,
    required this.addedFrom,
    required this.addedAt,
    required this.unitPrice, // مطلوب الآن
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

    // استخراج المنتج أولاً للحصول على السعر
    final product = extractProduct(json['product']);
    // الحصول على السعر المحفوظ أو من المنتج
    double unitPrice = (json['unitPrice'] ?? 0).toDouble();

    // إذا لم يكن السعر محفوظ، استخدم سعر المنتج
    if (unitPrice == 0 && product != null) {
      unitPrice = product.price;
    }

    return CartItem(
      objectId: json['objectId'] ?? '',
      userId: extractUserId(json['user']),
      productId: extractProductId(json['product']),
      product: product,
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'] ?? '',
      addedFrom: json['addedFrom'] ?? 'browse',
      addedAt: parseDate(json['addedAt']),
      unitPrice: unitPrice, // استخدام السعر المستخرج
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'__type': 'Pointer', 'className': '_User', 'objectId': userId},
      'product': {'__type': 'Pointer', 'className': 'Products', 'objectId': productId},
      'quantity': quantity,
      'selectedColor': selectedColor,
      'addedFrom': addedFrom,
      'unitPrice': unitPrice, // حفظ السعر
      'addedAt': {'__type': 'Date', 'iso': addedAt.toIso8601String()},
    };
  }

  // Helper methods - مُصلحة
  double get totalPrice {
    // استخدام السعر المحفوظ أولاً، ثم سعر المنتج
    final price = unitPrice > 0 ? unitPrice : (product?.price ?? 0);
    return price * quantity;
  }

  String get displayTotalPrice => '${totalPrice.toStringAsFixed(0)} ر.س';

  CartItem copyWith({
    String? objectId,
    int? quantity,
    String? selectedColor,
    double? unitPrice,
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
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}