// lib/presentation/navigation/bottom_navigation.dart (Updated)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../logic/providers/product_provider.dart';
import '../../logic/providers/cart_provider.dart';
import '../../logic/providers/uth_provider.dart';
import '../screens/products/products_home_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;

  const BottomNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  void _initializeProviders() {
    final authProvider = context.read<AuthProvider>();
    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    print('🔍 Initializing providers...');
    print('🔍 Auth status: ${authProvider.isAuthenticated}');
    print('🔍 User ID: ${authProvider.userId}');

    // Initialize products
    productProvider.initialize();

    // Load cart only if user is properly authenticated
    if (authProvider.isAuthenticated && authProvider.userId.isNotEmpty) {
      print('✅ Loading cart for user: ${authProvider.userId}');
      cartProvider.loadCart(authProvider.userId);
    } else {
      print('⚠️ User not authenticated, skipping cart load');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ProductsHomeScreen(),
          CartScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => _onTabTapped(index, authProvider),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.onSurfaceVariant,
            showUnselectedLabels: true,
            elevation: 8,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: _buildCartIcon(cartProvider.totalItems),
                activeIcon: _buildCartIcon(cartProvider.totalItems, isActive: true),
                label: AppStrings.cart,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: AppStrings.orders,
              ),
              BottomNavigationBarItem(
                icon: _buildProfileIcon(authProvider),
                activeIcon: _buildProfileIcon(authProvider, isActive: true),
                label: AppStrings.profile,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartIcon(int itemCount, {bool isActive = false}) {
    return Stack(
      children: [
        Icon(
          isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined,
        ),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileIcon(AuthProvider authProvider, {bool isActive = false}) {
    if (authProvider.isAuthenticated) {
      return Stack(
        children: [
          Icon(
            isActive ? Icons.person : Icons.person_outline,
          ),
          // Green dot to indicate logged in
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Icon(
      isActive ? Icons.person : Icons.person_outline,
    );
  }

  void _onTabTapped(int index, AuthProvider authProvider) {
    // Check if authentication is required for certain tabs
    if ((index == 1 || index == 2) && !authProvider.isAuthenticated) {
      _showLoginRequiredDialog(index);
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showLoginRequiredDialog(int targetIndex) {
    final String featureName = targetIndex == 1 ? 'السلة' : 'الطلبات';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الدخول مطلوب'),
        content: Text('لاستخدام $featureName، يجب تسجيل الدخول أولاً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to profile screen which will show login option
              setState(() {
                _currentIndex = 3;
              });
              _pageController.animateToPage(
                3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              'تسجيل الدخول',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}