// lib/data/services/order_service.dart - مُصلح
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/order_model.dart';
import '../models/cart_model.dart';
import 'back4app_service.dart';
import 'cart_service.dart';
import '../../core/constants/app_constants.dart';

class OrderService {
  // Create order from cart - مُصلح لحل مشكلة عدم ظهور الطلبات
  static Future<String?> createOrderFromCart(
      String userId,
      Map<String, dynamic> shippingAddress,
      Map<String, dynamic> contactInfo,
      String customerNotes, {
        bool fromSurvey = false,
        String? surveyId,
      }) async {
    try {
      print('🛒 Creating order for user: $userId');

      // Get cart items
      final cartItems = await CartService.getUserCart(userId);
      if (cartItems.isEmpty) {
        print('❌ Cart is empty for user: $userId');
        throw Exception('Cart is empty');
      }

      print('📦 Found ${cartItems.length} items in cart');

      // Calculate total and prepare order items
      double totalAmount = 0.0;
      List<Map<String, dynamic>> orderItems = [];

      for (var cartItem in cartItems) {
        if (1==1) {
          final itemTotal = cartItem.product!.price * cartItem.quantity;
          totalAmount += itemTotal;

          orderItems.add({
            'productId': cartItem.productId,
            'productName': cartItem.product!.arabicName,
            'quantity': cartItem.quantity,
            'color': cartItem.selectedColor,
            'price': cartItem.product!.price,
          });

          print('✅ Added item: ${cartItem.product!.arabicName} - ${itemTotal} ر.س');
        } else {
          print('⚠️ Skipping invalid cart item: ${cartItem.objectId}');
        }
      }

      if (orderItems.isEmpty) {
        throw Exception('No valid items in cart');
      }

      print('💰 Total amount: ${totalAmount} ر.س');

      // Generate order number
      final orderNumber = _generateOrderNumber();
      print('📋 Order number: $orderNumber');

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
        'createdAt': {'__type': 'Date', 'iso': DateTime.now().toIso8601String()},
        'updatedAt': {'__type': 'Date', 'iso': DateTime.now().toIso8601String()},
      };

      // Save order
      final orderId = await Back4AppService.create(AppConstants.ordersTable, orderData);

      if (orderId != null) {
        print('✅ Order created successfully: $orderId');

        // Clear cart after successful order
        final cartCleared = await CartService.clearCart(userId);
        if (cartCleared) {
          print('🗑️ Cart cleared after order creation');
        } else {
          print('⚠️ Failed to clear cart after order creation');
        }

        return orderId;
      } else {
        print('❌ Failed to create order in database');
        return null;
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      return null;
    }
  }

  // Get user's orders - مُحسن
  static Future<List<Order>> getUserOrders(String userId) async {
    try {
      print('📋 Loading orders for user: $userId');

      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.ordersTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.orderByDescending('createdAt');

      // تحديد حد أقصى للنتائج
      query.setLimit(50);

      final results = await Back4AppService.queryWithConditions(query);

      final orders = <Order>[];

      for (final result in results) {
        try {
          final order = Order.fromJson(result.toJson());
          orders.add(order);
          print('✅ Loaded order: ${order.orderNumber}');
        } catch (e) {
          print('❌ Error parsing order: ${result.objectId} - $e');
          continue;
        }
      }

      print('📋 Total orders loaded: ${orders.length}');
      return orders;
    } catch (e) {
      print('❌ Error getting user orders: $e');
      return [];
    }
  }

  // Get order by ID - مُحسن
  static Future<Order?> getOrderById(String orderId) async {
    try {
      print('🔍 Loading order: $orderId');

      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.ordersTable);
      query.whereEqualTo('objectId', orderId);

      final results = await Back4AppService.queryWithConditions(query);

      if (results.isNotEmpty) {
        final order = Order.fromJson(results.first.toJson());
        print('✅ Order loaded: ${order.orderNumber}');
        return order;
      } else {
        print('❌ Order not found: $orderId');
        return null;
      }
    } catch (e) {
      print('❌ Error getting order by ID: $e');
      return null;
    }
  }

  // Update order status (for admin) - مُحسن
  static Future<bool> updateOrderStatus(
      String orderId,
      String newStatus, {
        String? adminResponse,
        String? note,
      }) async {
    try {
      print('🔄 Updating order status: $orderId -> $newStatus');

      final order = await getOrderById(orderId);
      if (order == null) {
        print('❌ Order not found for status update: $orderId');
        return false;
      }

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
        'updatedAt': {'__type': 'Date', 'iso': DateTime.now().toIso8601String()},
      };

      if (adminResponse != null) {
        updateData['adminResponse'] = adminResponse;
      }

      final success = await Back4AppService.update(AppConstants.ordersTable, orderId, updateData);

      if (success) {
        print('✅ Order status updated successfully');
      } else {
        print('❌ Failed to update order status');
      }

      return success;
    } catch (e) {
      print('❌ Error updating order status: $e');
      return false;
    }
  }

  // Generate unique order number - مُحسن
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

  // Get order statistics
  static Future<Map<String, int>> getOrderStatistics(String userId) async {
    try {
      final orders = await getUserOrders(userId);

      final stats = <String, int>{
        'total': orders.length,
        'pending': 0,
        'confirmed': 0,
        'processing': 0,
        'shipped': 0,
        'delivered': 0,
        'cancelled': 0,
      };

      for (final order in orders) {
        stats[order.status] = (stats[order.status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('❌ Error getting order statistics: $e');
      return {
        'total': 0,
        'pending': 0,
        'confirmed': 0,
        'processing': 0,
        'shipped': 0,
        'delivered': 0,
        'cancelled': 0,
      };
    }
  }
}