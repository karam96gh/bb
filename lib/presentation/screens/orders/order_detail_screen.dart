// lib/presentation/screens/orders/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/order_model.dart';
import '../../../logic/providers/order_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.orderDetails),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = orderProvider.currentOrder;
          if (order == null) {
            return _buildNotFoundView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                _buildOrderHeader(context, order),

                const SizedBox(height: 24),

                // Order Status Timeline
                _buildStatusTimeline(context, order),

                const SizedBox(height: 24),

                // Order Items
                _buildOrderItems(context, order),

                const SizedBox(height: 24),

                // Order Summary
                _buildOrderSummary(context, order),

                const SizedBox(height: 24),

                // Shipping Information
                _buildShippingInfo(context, order),

                const SizedBox(height: 24),

                // Contact Information
                _buildContactInfo(context, order),

                if (order.customerNotes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildCustomerNotes(context, order),
                ],

                if (order.adminResponse.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildAdminResponse(context, order),
                ],

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotFoundView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'الطلب غير موجود',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على الطلب المطلوب',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.orderNumber}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoRow('تاريخ الطلب', _formatDate(order.createdAt)),
          _buildInfoRow('عدد القطع', '${order.itemsCount} قطعة'),
          _buildInfoRow('المبلغ الإجمالي', order.displayTotalAmount),
          if (order.fromSurvey)
            _buildInfoRow('مصدر الطلب', 'توصيات الاستطلاع'),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تتبع الطلب',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...order.statusHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isLast = index == order.statusHistory.length - 1;

            return _buildTimelineItem(
              context,
              status.status,
              _getStatusDisplayName(status.status),
              _formatDateTime(status.timestamp),
              status.note,
              isLast,
            );
          }).toList(),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 200))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildTimelineItem(
      BuildContext context,
      String status,
      String title,
      String time,
      String? note,
      bool isLast,
      ) {
    final color = _getStatusColor(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: color.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  note,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المنتجات المطلوبة',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...order.items.map((item) => _buildOrderItem(context, item)).toList(),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 400))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.color.isNotEmpty)
                  Text(
                    'اللون: ${item.color}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الكمية: ${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      item.displayTotalPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الطلب',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('المجموع الفرعي', order.displayTotalAmount),
          _buildSummaryRow('الشحن', 'مجاني'),
          const Divider(height: 20),
          _buildSummaryRow(
            'المجموع الإجمالي',
            order.displayTotalAmount,
            isTotal: true,
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isTotal ? AppColors.onSurface : AppColors.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isTotal ? AppColors.primary : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'معلومات الشحن',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('الاسم', order.shippingAddress['fullName'] ?? ''),
          _buildInfoRow('الهاتف', order.shippingAddress['phone'] ?? ''),
          _buildInfoRow('العنوان', order.shippingAddress['address'] ?? ''),
          _buildInfoRow('المدينة', order.shippingAddress['city'] ?? ''),
          if (order.shippingAddress['postalCode'] != null && order.shippingAddress['postalCode'].isNotEmpty)
            _buildInfoRow('الرمز البريدي', order.shippingAddress['postalCode']),
          if (order.shippingAddress['additionalInfo'] != null && order.shippingAddress['additionalInfo'].isNotEmpty)
            _buildInfoRow('معلومات إضافية', order.shippingAddress['additionalInfo']),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 800))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildContactInfo(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_phone_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'معلومات التواصل',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (order.contactInfo['email'] != null && order.contactInfo['email'].isNotEmpty)
            _buildInfoRow('البريد الإلكتروني', order.contactInfo['email']),
          if (order.contactInfo['alternativePhone'] != null && order.contactInfo['alternativePhone'].isNotEmpty)
            _buildInfoRow('هاتف بديل', order.contactInfo['alternativePhone']),
          if (order.contactInfo['preferredContactTime'] != null && order.contactInfo['preferredContactTime'].isNotEmpty)
            _buildInfoRow('الوقت المفضل للتواصل', order.contactInfo['preferredContactTime']),
          if (order.contactInfo['communicationMethod'] != null)
            _buildInfoRow('طريقة التواصل المفضلة', _getCommunicationMethodText(order.contactInfo['communicationMethod'])),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 1000))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildCustomerNotes(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'ملاحظات العميل',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order.customerNotes,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 1200))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildAdminResponse(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'رد الإدارة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order.adminResponse,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 1400))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
      case 'processing':
        return AppColors.info;
      case 'shipped':
        return AppColors.primary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'pending':
        return 'في انتظار التأكيد';
      case 'confirmed':
        return 'تم التأكيد';
      case 'processing':
        return 'قيد التحضير';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'تم الإلغاء';
      default:
        return 'غير معروف';
    }
  }

  String _getCommunicationMethodText(String method) {
    switch (method) {
      case 'phone':
        return 'مكالمة هاتفية';
      case 'sms':
        return 'رسالة نصية';
      case 'email':
        return 'بريد إلكتروني';
      case 'whatsapp':
        return 'واتساب';
      default:
        return method;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${_formatDate(date)} - $hour:$minute';
  }
}