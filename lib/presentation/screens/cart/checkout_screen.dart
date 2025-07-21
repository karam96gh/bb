// lib/presentation/screens/cart/checkout_screen.dart (Complete Version)
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/cart_model.dart';
import '../../../logic/providers/order_provider.dart';
import '../../../logic/providers/cart_provider.dart';
import '../../../logic/providers/uth_provider.dart';
import '../orders/order_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternativePhoneController = TextEditingController();
  final _notesController = TextEditingController();

  int _currentStep = 0;
  String _preferredContactTime = 'أي وقت';
  String _communicationMethod = 'phone';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      _fullNameController.text = authProvider.fullName;
      _emailController.text = authProvider.email;
      _phoneController.text = authProvider.phone;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _additionalInfoController.dispose();
    _emailController.dispose();
    _alternativePhoneController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.checkout),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    _buildShippingStep(),
                    _buildContactStep(),
                    _buildReviewStep(),
                  ],
                ),
              ),

              // Bottom Navigation
              _buildBottomNavigation(orderProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStepIndicator(0, 'الشحن', Icons.local_shipping),
          Expanded(child: _buildStepLine(0)),
          _buildStepIndicator(1, 'التواصل', Icons.contact_phone),
          Expanded(child: _buildStepLine(1)),
          _buildStepIndicator(2, 'المراجعة', Icons.check_circle),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: -0.5,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildStepIndicator(int step, String title, IconData icon) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : AppColors.onSurfaceVariant,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;

    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isCompleted ? AppColors.primary : AppColors.surfaceVariant,
    );
  }

  Widget _buildShippingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الشحن',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .slideX(
              begin: 0.3,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            )
                .fadeIn(),

            const SizedBox(height: 24),

            _buildTextField(
              controller: _fullNameController,
              label: 'الاسم الكامل',
              hint: 'ادخلي اسمك الكامل',
              icon: Icons.person_outline,
              isRequired: true,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'رقم الهاتف',
              hint: 'ادخلي رقم هاتفك',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isRequired: true,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _addressController,
              label: 'العنوان',
              hint: 'ادخلي عنوانك بالتفصيل',
              icon: Icons.location_on_outlined,
              maxLines: 3,
              isRequired: true,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'المدينة',
                    hint: 'اختاري مدينتك',
                    icon: Icons.location_city_outlined,
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _postalCodeController,
                    label: 'الرمز البريدي',
                    hint: 'اختياري',
                    icon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _additionalInfoController,
              label: 'معلومات إضافية',
              hint: 'أي تفاصيل إضافية للوصول (اختياري)',
              icon: Icons.info_outline,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات التواصل',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .slideX(
            begin: 0.3,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          )
              .fadeIn(),

          const SizedBox(height: 24),

          _buildTextField(
            controller: _emailController,
            label: 'البريد الإلكتروني',
            hint: 'ادخلي بريدك الإلكتروني',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _alternativePhoneController,
            label: 'هاتف بديل',
            hint: 'رقم هاتف آخر للتواصل (اختياري)',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 24),

          // Preferred Contact Time
          Text(
            'الوقت المفضل للتواصل',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['صباحاً', 'ظهراً', 'مساءً', 'أي وقت'].map((time) {
              return ChoiceChip(
                label: Text(time),
                selected: _preferredContactTime == time,
                onSelected: (selected) {
                  setState(() {
                    _preferredContactTime = time;
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: _preferredContactTime == time
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Communication Method
          Text(
            'طريقة التواصل المفضلة',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('مكالمة هاتفية'),
                value: 'phone',
                groupValue: _communicationMethod,
                onChanged: (value) {
                  setState(() {
                    _communicationMethod = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
              RadioListTile<String>(
                title: const Text('رسالة نصية'),
                value: 'sms',
                groupValue: _communicationMethod,
                onChanged: (value) {
                  setState(() {
                    _communicationMethod = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
              RadioListTile<String>(
                title: const Text('واتساب'),
                value: 'whatsapp',
                groupValue: _communicationMethod,
                onChanged: (value) {
                  setState(() {
                    _communicationMethod = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildTextField(
            controller: _notesController,
            label: 'ملاحظات إضافية',
            hint: 'أي ملاحظات أو طلبات خاصة (اختياري)',
            icon: Icons.note_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final totalAmount = widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مراجعة الطلب',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .slideX(
            begin: 0.3,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          )
              .fadeIn(),

          const SizedBox(height: 24),

          // Order Items
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المنتجات (${widget.cartItems.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.cartItems.map((item) => _buildReviewItem(item)).toList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المجموع',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${totalAmount.toStringAsFixed(0)} ر.س',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Shipping Info
          _buildReviewSection(
            'معلومات الشحن',
            [
              'الاسم: ${_fullNameController.text}',
              'الهاتف: ${_phoneController.text}',
              'العنوان: ${_addressController.text}',
              'المدينة: ${_cityController.text}',
              if (_postalCodeController.text.isNotEmpty)
                'الرمز البريدي: ${_postalCodeController.text}',
            ],
          ),

          const SizedBox(height: 16),

          // Contact Info
          _buildReviewSection(
            'معلومات التواصل',
            [
              if (_emailController.text.isNotEmpty)
                'البريد الإلكتروني: ${_emailController.text}',
              'الوقت المفضل: $_preferredContactTime',
              'طريقة التواصل: ${_getCommunicationMethodText(_communicationMethod)}',
              if (_alternativePhoneController.text.isNotEmpty)
                'هاتف بديل: ${_alternativePhoneController.text}',
            ],
          ),

          if (_notesController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildReviewSection(
              'ملاحظات إضافية',
              [_notesController.text],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewItem(CartItem item) {
    final product = item.product;
    if (product == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.arabicName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.selectedColor.isNotEmpty)
                  Text(
                    'اللون: ${item.selectedColor}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${item.quantity}x',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          Text(
            item.displayTotalPrice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
          ),
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return '$label مطلوب';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(OrderProvider orderProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _goToPreviousStep(),
                child: const Text('السابق'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: orderProvider.isPlacingOrder
                  ? null
                  : _currentStep < 2
                  ? _goToNextStep
                  : _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: orderProvider.isPlacingOrder
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                _currentStep < 2 ? 'التالي' : 'تأكيد الطلب',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep == 0 && !_validateShippingForm()) return;

    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateShippingForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _placeOrder() async {
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();

    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تسجيل الدخول أولاً'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final shippingInfo = {
      'fullName': _fullNameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'postalCode': _postalCodeController.text,
      'additionalInfo': _additionalInfoController.text,
    };

    final contactInfo = {
      'email': _emailController.text,
      'alternativePhone': _alternativePhoneController.text,
      'preferredContactTime': _preferredContactTime,
      'communicationMethod': _communicationMethod,
    };

    final orderId = await orderProvider.createOrderFromCart(
      authProvider.userId,
      shippingInfo,
      contactInfo,
      _notesController.text,
    );

    if (orderId != null && mounted) {
      // Clear cart
      await cartProvider.clearCart(authProvider.userId);

      // Navigate to order details
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderDetailScreen(orderId: orderId),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال طلبك بنجاح!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'فشل في إرسال الطلب'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _getCommunicationMethodText(String method) {
    switch (method) {
      case 'phone': return 'مكالمة هاتفية';
      case 'sms': return 'رسالة نصية';
      case 'whatsapp': return 'واتساب';
      default: return method;
    }
  }
}