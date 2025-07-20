class Order {
  final String objectId;
  final String userId;
  final String orderNumber;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final bool fromSurvey;
  final String? surveyId;
  final String customerNotes;
  final String adminResponse;
  final Map<String, dynamic> shippingAddress;
  final Map<String, dynamic> contactInfo;
  final List<OrderStatusHistory> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.objectId,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.fromSurvey,
    this.surveyId,
    required this.customerNotes,
    required this.adminResponse,
    required this.shippingAddress,
    required this.contactInfo,
    required this.statusHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      objectId: json['objectId'] ?? '',
      userId: json['user']?['objectId'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      fromSurvey: json['fromSurvey'] ?? false,
      surveyId: json['surveyId'],
      customerNotes: json['customerNotes'] ?? '',
      adminResponse: json['adminResponse'] ?? '',
      shippingAddress: Map<String, dynamic>.from(json['shippingAddress'] ?? {}),
      contactInfo: Map<String, dynamic>.from(json['contactInfo'] ?? {}),
      statusHistory: (json['statusHistory'] as List? ?? [])
          .map((history) => OrderStatusHistory.fromJson(history))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'__type': 'Pointer', 'className': '_User', 'objectId': userId},
      'orderNumber': orderNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'fromSurvey': fromSurvey,
      'surveyId': surveyId,
      'customerNotes': customerNotes,
      'adminResponse': adminResponse,
      'shippingAddress': shippingAddress,
      'contactInfo': contactInfo,
      'statusHistory': statusHistory.map((history) => history.toJson()).toList(),
    };
  }

  // Helper methods
  String get displayTotalAmount => '${totalAmount.toStringAsFixed(0)} ر.س';
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'في انتظار التأكيد';
      case 'confirmed':
        return 'مؤكد';
      case 'processing':
        return 'قيد التحضير';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final String color;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.color,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 1,
      color: json['color'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'color': color,
      'price': price,
    };
  }

  double get totalPrice => price * quantity;
  String get displayTotalPrice => '${totalPrice.toStringAsFixed(0)} ر.س';
}

class OrderStatusHistory {
  final String status;
  final DateTime timestamp;
  final String? note;

  OrderStatusHistory({
    required this.status,
    required this.timestamp,
    this.note,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      status: json['status'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }
}