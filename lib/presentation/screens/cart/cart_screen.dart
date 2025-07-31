// lib/presentation/screens/cart/cart_screen.dart - مُصلح
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/cart_provider.dart';
import '../../../logic/providers/uth_provider.dart';
import '../../../data/models/cart_model.dart';
import 'checkout_screen.dart';
import '../auth/login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load cart data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserCart();
    });
  }


  void _loadUserCart() {
    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();

    print('🔍 Auth check - isAuthenticated: ${authProvider.isAuthenticated}');
    print('🔍 Auth check - userId: ${authProvider.userId}');
    print('🔍 Auth check - email: ${authProvider.email}');

    if (authProvider.isAuthenticated && authProvider.userId.isNotEmpty) {
      print('✅ Loading cart for authenticated user: ${authProvider.userId}');
      cartProvider.loadCart(authProvider.userId);
    } else {
      print('❌ User not authenticated or userId is empty');
      // يمكن إنشاء guest cart هنا إذا أردت
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.cart),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer2<CartProvider, AuthProvider>(
            builder: (context, cartProvider, authProvider, child) {
              if (authProvider.isAuthenticated && cartProvider.cartItems.isNotEmpty) {
                return TextButton(
                  onPressed: () => _showClearCartDialog(cartProvider, authProvider),
                  child: Text(
                    'إفراغ',
                    style: TextStyle(color: AppColors.error),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          // Check if user is authenticated
          if (!authProvider.isAuthenticated) {
            return _buildLoginRequired();
          }

          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: _buildCartList(cartProvider, authProvider),
              ),

              // Summary and Checkout
              _buildBottomSection(cartProvider, authProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginRequired() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 120,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),

          const SizedBox(height: 32),

          Text(
            'تسجيل الدخول مطلوب',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'لاستخدام السلة وإتمام الطلبات، يجب تسجيل الدخول أولاً',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _navigateToLogin(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
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

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          )
              .animate()
              .scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 32),

          Text(
            AppStrings.emptyCart,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn()
              .slideY(begin: 0.3, curve: Curves.easeOut),

          const SizedBox(height: 16),

          Text(
            'لم تقومي بإضافة أي منتجات للسلة بعد\nابدئي التسوق واكتشفي منتجاتنا الرائعة',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 400))
              .fadeIn()
              .slideY(begin: 0.2, curve: Curves.easeOut),

          const SizedBox(height: 40),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to products tab
                DefaultTabController.of(context)?.animateTo(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ابدئي التسوق',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              .animate(delay: const Duration(milliseconds: 600))
              .fadeIn()
              .slideY(begin: 0.3, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildCartList(CartProvider cartProvider, AuthProvider authProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildCartItemCard(cartItem, cartProvider, authProvider),
        )
            .animate(delay: Duration(milliseconds: 100 + (index * 50)))
            .slideX(
          begin: 0.3,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        )
            .fadeIn();
      },
    );
  }

  Widget _buildCartItemCard(CartItem cartItem, CartProvider cartProvider, AuthProvider authProvider) {
    final product = cartItem.product;
    if (product == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.images.isNotEmpty
                  ? Image.network(
                product.images.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.shopping_bag,
                    color: AppColors.onSurfaceVariant,
                    size: 32,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  );
                },
              )
                  : Icon(
                Icons.shopping_bag,
                color: AppColors.onSurfaceVariant,
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.arabicName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  product.brand,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                if (cartItem.selectedColor.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'اللون: ${cartItem.selectedColor}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cartItem.displayTotalPrice,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Quantity Controls
                    _buildQuantityControls(cartItem, cartProvider, authProvider),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: () => _removeItem(cartItem, cartProvider, authProvider),
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(CartItem cartItem, CartProvider cartProvider, AuthProvider authProvider) {
    return Row(
      children: [
        // Decrease Button
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.surfaceVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: cartItem.quantity > 1
                ? () => _updateQuantity(cartItem, cartItem.quantity - 1, cartProvider, authProvider)
                : null,
            child: Container(
              width: 32,
              height: 32,
              child: Icon(
                Icons.remove,
                size: 16,
                color: cartItem.quantity > 1
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),

        // Quantity
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            cartItem.quantity.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Increase Button
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.surfaceVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _updateQuantity(cartItem, cartItem.quantity + 1, cartProvider, authProvider),
            child: Container(
              width: 32,
              height: 32,
              child: Icon(
                Icons.add,
                size: 16,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(CartProvider cartProvider, AuthProvider authProvider) {
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
      child: SafeArea(
        child: Column(
          children: [
            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المجموع (${cartProvider.totalItems} قطعة)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  cartProvider.totalAmountText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToCheckout(cartProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.checkout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(CartItem cartItem, int newQuantity, CartProvider cartProvider, AuthProvider authProvider) async {
    await cartProvider.updateQuantity(authProvider.userId, cartItem.objectId, newQuantity);
  }

  void _removeItem(CartItem cartItem, CartProvider cartProvider, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إزالة المنتج'),
        content: Text('هل تريدين إزالة ${cartItem.product?.arabicName} من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'إزالة',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cartProvider.removeFromCart(authProvider.userId, cartItem.objectId);
    }
  }

  void _showClearCartDialog(CartProvider cartProvider, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إفراغ السلة'),
        content: const Text('هل تريدين إزالة جميع المنتجات من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await cartProvider.clearCart(authProvider.userId);
            },
            child: Text(
              'إفراغ',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCheckout(CartProvider cartProvider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cartItems: cartProvider.cartItems),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}