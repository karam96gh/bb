
// lib/presentation/screens/products/products_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/product_provider.dart';
import '../../../logic/providers/cart_provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import 'search_screen.dart';
import 'products_by_category_screen.dart';
import 'product_detail_screen.dart';

class ProductsHomeScreen extends StatefulWidget {
  const ProductsHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more products
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                _buildSliverAppBar(context),

                // Search Bar
                _buildSearchBar(context),

                // Categories Section
                if (productProvider.categories.isNotEmpty)
                  _buildCategoriesSection(context, productProvider.categories),

                // Featured Products Section
                if (productProvider.featuredProducts.isNotEmpty)
                  _buildFeaturedProductsSection(context, productProvider.featuredProducts),

                // All Products Section
                _buildAllProductsSection(context, productProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppStrings.appName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'اكتشفي جمالك الطبيعي',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _navigateToSearch(context),
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Navigate to cart
                    DefaultTabController.of(context)?.animateTo(1);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                ),
                if (cartProvider.totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartProvider.totalItems.toString(),
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
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => _navigateToSearch(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  'ابحثي عن منتجك المفضل...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .slideY(
        begin: -0.3,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      )
          .fadeIn(),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, List<Category> categories) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppStrings.categories,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(left: 12),
                  child: _buildCategoryCard(context, category),
                )
                    .animate(delay: Duration(milliseconds: 100 + (index * 50)))
                    .slideX(
                  begin: 0.3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                )
                    .fadeIn();
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () => _navigateToCategory(context, category),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.getCategoryColor(category.name).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                _getCategoryIcon(category.name),
                color: AppColors.getCategoryColor(category.name),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.arabicName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (category.productCount > 0)
              Text(
                '${category.productCount} منتج',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProductsSection(BuildContext context, List<Product> featuredProducts) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'المنتجات المميزة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(left: 12),
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(context, product),
                  ),
                )
                    .animate(delay: Duration(milliseconds: 150 + (index * 75)))
                    .slideX(
                  begin: 0.4,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                )
                    .fadeIn();
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAllProductsSection(BuildContext context, ProductProvider productProvider) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'جميع المنتجات',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showSortOptions(context, productProvider),
                  icon: Icon(Icons.sort, size: 20),
                  label: Text('ترتيب'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Products Grid
          if (productProvider.isLoading && productProvider.filteredProducts.isEmpty)
            const Center(child: LoadingWidget()),

          if (productProvider.filteredProducts.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: productProvider.filteredProducts.length +
                  (productProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= productProvider.filteredProducts.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = productProvider.filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(context, product),
                )
                    .animate(delay: Duration(milliseconds: 50 + (index % 6 * 25)))
                    .slideY(
                  begin: 0.3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                )
                    .fadeIn();
              },
            ),

          if (productProvider.error != null)
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    productProvider.error!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => productProvider.refresh(),
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'lipstick':
        return Icons.face_retouching_natural;
      case 'mascara':
        return Icons.remove_red_eye;
      case 'lip balm':
        return Icons.healing;
      default:
        return Icons.shopping_bag;
    }
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductsByCategoryScreen(category: category),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _showSortOptions(BuildContext context, ProductProvider productProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = [
          {'key': 'newest', 'title': 'الأحدث'},
          {'key': 'rating', 'title': 'الأعلى تقييماً'},
          {'key': 'price_low', 'title': 'السعر: من الأقل للأعلى'},
          {'key': 'price_high', 'title': 'السعر: من الأعلى للأقل'},
        ];

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ترتيب حسب',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map((option) {
                final isSelected = productProvider.sortBy == option['key'];
                return ListTile(
                  title: Text(option['title']!),
                  trailing: isSelected
                      ? Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    productProvider.sortProducts(option['key']!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}