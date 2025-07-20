// lib/logic/providers/order_provider.dart
import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  // Orders State
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  bool _isPlacingOrder = false;
  String? _error;

  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  bool get isPlacingOrder => _isPlacingOrder;
  String? get error => _error;

  bool get hasOrders => _orders.isNotEmpty;
  int get ordersCount => _orders.length;

  // Get orders by status
  List<Order> get pendingOrders =>
      _orders.where((order) => order.isPending).toList();
  List<Order> get confirmedOrders =>
      _orders.where((order) => order.isConfirmed).toList();
  List<Order> get processingOrders =>
      _orders.where((order) => order.isProcessing).toList();
  List<Order> get shippedOrders =>
      _orders.where((order) => order.isShipped).toList();
  List<Order> get deliveredOrders =>
      _orders.where((order) => order.isDelivered).toList();
  List<Order> get cancelledOrders =>
      _orders.where((order) => order.isCancelled).toList();

  // Load user's orders
  Future<void> loadOrders(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _orders = await OrderService.getUserOrders(userId);
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = 'خطأ في تحميل الطلبات: $e';
      print('❌ Error loading orders: $e');
    }

    _setLoading(false);
  }

  // Create order from cart
  Future<String?> createOrderFromCart(
      String userId,
      Map<String, String> shippingInfo,
      Map<String, String> contactInfo,
      String notes, {
        bool fromSurvey = false,
        String? surveyId,
      }) async {
    _isPlacingOrder = true;
    _error = null;
    notifyListeners();

    try {
      // Prepare shipping address
      final shippingAddress = {
        'fullName': shippingInfo['fullName'] ?? '',
        'phone': shippingInfo['phone'] ?? '',
        'address': shippingInfo['address'] ?? '',
        'city': shippingInfo['city'] ?? '',
        'postalCode': shippingInfo['postalCode'] ?? '',
        'additionalInfo': shippingInfo['additionalInfo'] ?? '',
      };

      // Prepare contact info
      final contactData = {
        'email': contactInfo['email'] ?? '',
        'alternativePhone': contactInfo['alternativePhone'] ?? '',
        'preferredContactTime': contactInfo['preferredContactTime'] ?? '',
        'communicationMethod': contactInfo['communicationMethod'] ?? 'phone',
      };

      final orderId = await OrderService.createOrderFromCart(
        userId,
        shippingAddress,
        contactData,
        notes,
        fromSurvey: fromSurvey,
        surveyId: surveyId,
      );

      if (orderId != null) {
        // Reload orders to include the new one
        await loadOrders(userId);

        // Set current order
        _currentOrder = _orders.firstWhere(
              (order) => order.objectId == orderId,
          orElse: () => _orders.first,
        );

        _isPlacingOrder = false;
        notifyListeners();
        return orderId;
      } else {
        _error = 'فشل في إنشاء الطلب';
        _isPlacingOrder = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'خطأ في إنشاء الطلب: $e';
      print('❌ Error creating order: $e');
      _isPlacingOrder = false;
      notifyListeners();
      return null;
    }
  }

  // Get order details
  Future<Order?> getOrderDetails(String orderId) async {
    try {
      // Check if order is already loaded
      final existingOrder = _orders.firstWhere(
            (order) => order.objectId == orderId,
        orElse: () => Order(
          objectId: '',
          userId: '',
          orderNumber: '',
          items: [],
          totalAmount: 0,
          status: '',
          fromSurvey: false,
          customerNotes: '',
          adminResponse: '',
          shippingAddress: {},
          contactInfo: {},
          statusHistory: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (existingOrder.objectId.isNotEmpty) {
        _currentOrder = existingOrder;
        notifyListeners();
        return existingOrder;
      }

      // Load from service
      final order = await OrderService.getOrderById(orderId);
      if (order != null) {
        _currentOrder = order;
        notifyListeners();
      }
      return order;
    } catch (e) {
      _error = 'خطأ في تحميل تفاصيل الطلب: $e';
      print('❌ Error getting order details: $e');
      notifyListeners();
      return null;
    }
  }

  // Update order status (for admin)
  Future<bool> updateOrderStatus(
      String orderId,
      String newStatus, {
        String? adminResponse,
        String? note,
      }) async {
    try {
      final success = await OrderService.updateOrderStatus(
        orderId,
        newStatus,
        adminResponse: adminResponse,
        note: note,
      );

      if (success) {
        // Update local order if it exists
        final orderIndex = _orders.indexWhere((order) => order.objectId == orderId);
        if (orderIndex != -1) {
          // Reload the specific order to get updated data
          final updatedOrder = await OrderService.getOrderById(orderId);
          if (updatedOrder != null) {
            _orders[orderIndex] = updatedOrder;

            // Update current order if it's the same
            if (_currentOrder?.objectId == orderId) {
              _currentOrder = updatedOrder;
            }

            notifyListeners();
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = 'خطأ في تحديث حالة الطلب: $e';
      print('❌ Error updating order status: $e');
      notifyListeners();
      return false;
    }
  }

  // Get order statistics
  Map<String, int> getOrderStatistics() {
    return {
      'total': _orders.length,
      'pending': pendingOrders.length,
      'confirmed': confirmedOrders.length,
      'processing': processingOrders.length,
      'shipped': shippedOrders.length,
      'delivered': deliveredOrders.length,
      'cancelled': cancelledOrders.length,
    };
  }

  // Get total spent amount
  double getTotalSpentAmount() {
    return _orders
        .where((order) => order.isDelivered)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get most recent order
  Order? getMostRecentOrder() {
    if (_orders.isEmpty) return null;
    return _orders.first;
  }

  // Search orders
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return _orders;

    return _orders.where((order) {
      return order.orderNumber.toLowerCase().contains(query.toLowerCase()) ||
          order.status.toLowerCase().contains(query.toLowerCase()) ||
          order.items.any((item) =>
              item.productName.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Filter orders by status
  List<Order> filterOrdersByStatus(String status) {
    if (status.isEmpty || status == 'all') return _orders;
    return _orders.where((order) => order.status == status).toList();
  }

  // Filter orders by date range
  List<Order> filterOrdersByDateRange(DateTime start, DateTime end) {
    return _orders.where((order) {
      return order.createdAt.isAfter(start.subtract(Duration(days: 1))) &&
          order.createdAt.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }

  // Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  // Refresh orders
  Future<void> refreshOrders(String userId) async {
    await loadOrders(userId);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}