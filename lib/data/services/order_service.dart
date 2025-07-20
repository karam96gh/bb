// lib/data/services/order_service.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/order_model.dart';
import '../models/cart_model.dart';
import 'back4app_service.dart';
import 'cart_service.dart';
import '../../core/constants/app_constants.dart';

class OrderService {
  // Create order from cart
  static Future<String?> createOrderFromCart(
      String userId,
      Map<String, dynamic> shippingAddress,
      Map<String, dynamic> contactInfo,
      String customerNotes, {
        bool fromSurvey = false,
        String? surveyId,
      }) async {
    try {
      // Get cart items
      final cartItems = await CartService.getUserCart(userId);
      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      // Calculate total
      double totalAmount = 0.0;
      List<Map<String, dynamic>> orderItems = [];

      for (var cartItem in cartItems) {
        if (cartItem.product != null) {
          totalAmount += cartItem.totalPrice;
          orderItems.add({
            'productId': cartItem.productId,
            'productName': cartItem.product!.arabicName,
            'quantity': cartItem.quantity,
            'color': cartItem.selectedColor,
            'price': cartItem.product!.price,
          });
        }
      }

      // Generate order number
      final orderNumber = _generateOrderNumber();

      // Create order data
      final orderData = {
        'user': {'__type': 'Pointer', 'className': '_User', 'objectId': userId},
        'orderNumber': orderNumber,
        'items': orderItems,
        'totalAmount': totalAmount,
        'status': AppConstants.pendingStatus,
        'fromSurvey': fromSurvey,
        'surveyId': surveyId,
        'customerNotes': customerNotes,
        'adminResponse': '',
        'shippingAddress': shippingAddress,
        'contactInfo': contactInfo,
        'statusHistory': [
          {
            'status': AppConstants.pendingStatus,
            'timestamp': DateTime.now().toIso8601String(),
            'note': 'تم إنشاء الطلب',
          }
        ],
      };

      // Save order
      final orderId = await Back4AppService.create(AppConstants.ordersTable, orderData);

      if (orderId != null) {
        // Clear cart after successful order
        await CartService.clearCart(userId);
      }

      return orderId;
    } catch (e) {
      print('❌ Error creating order: $e');
      return null;
    }
  }

  // Get user's orders
  static Future<List<Order>> getUserOrders(String userId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.ordersTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.orderByDescending('createdAt');

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => Order.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting user orders: $e');
      return [];
    }
  }

  // Get order by ID
  static Future<Order?> getOrderById(String orderId) async {
    try {
      final result = await Back4AppService.getById<ParseObject>(AppConstants.ordersTable, orderId);
      if (result != null) {
        return Order.fromJson(result.toJson());
      }
      return null;
    } catch (e) {
      print('❌ Error getting order by ID: $e');
      return null;
    }
  }

  // Update order status (for admin)
  static Future<bool> updateOrderStatus(
      String orderId,
      String newStatus, {
        String? adminResponse,
        String? note,
      }) async {
    try {
      final order = await getOrderById(orderId);
      if (order == null) return false;

      // Add to status history
      final newStatusHistory = List<Map<String, dynamic>>.from(
        order.statusHistory.map((h) => h.toJson()),
      );

      newStatusHistory.add({
        'status': newStatus,
        'timestamp': DateTime.now().toIso8601String(),
        'note': note ?? _getStatusNote(newStatus),
      });

      final updateData = <String, dynamic>{
        'status': newStatus,
        'statusHistory': newStatusHistory,
      };

      if (adminResponse != null) {
        updateData['adminResponse'] = adminResponse;
      }

      return await Back4AppService.update(AppConstants.ordersTable, orderId, updateData);
    } catch (e) {
      print('❌ Error updating order status: $e');
      return false;
    }
  }

  // Generate unique order number
  static String _generateOrderNumber() {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    final random = (now.millisecond % 1000).toString().padLeft(3, '0');
    return 'BM$timestamp$random';
  }

  // Get status note in Arabic
  static String _getStatusNote(String status) {
    switch (status) {
      case AppConstants.confirmedStatus:
        return 'تم تأكيد الطلب';
      case AppConstants.processingStatus:
        return 'جاري تحضير الطلب';
      case AppConstants.shippedStatus:
        return 'تم شحن الطلب';
      case AppConstants.deliveredStatus:
        return 'تم تسليم الطلب';
      case AppConstants.cancelledStatus:
        return 'تم إلغاء الطلب';
      default:
        return 'تحديث حالة الطلب';
    }
  }
}
