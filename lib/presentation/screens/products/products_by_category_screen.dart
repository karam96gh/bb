// lib/presentation/screens/products/products_by_category_screen.dart - مكتملة
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import 'product_detail_screen.dart';

class ProductsByCategoryScreen extends StatefulWidget {
  final Category category;

  const ProductsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ProductsByCategoryScreen> createState() => _ProductsByCategoryScreenState();
}

class _ProductsByCategoryScreenState extends State<ProductsByCategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _categoryProducts = [];
  bool _isLoading = true;
  String? _error;
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more products if needed
      _loadMoreProducts();
    }
  }

  Future<void> _loadCategoryProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final productProvider = context.read<ProductProvider>();
      final products = await productProvider.getProductsByCategory(widget.category.objectId);

      setState(() {
        _categoryProducts = products;
        _isLoading = false;
      });

      _applySorting();
    } catch (e) {
      setState(() {
        _error = 'خطأ في تحميل منتجات ${widget.category.arabicName}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    // يمكن إضافة pagination هنا لاحقاً
  }

  void _applySorting() {
    setState(() {
      switch (_sortBy) {
        case 'rating':
          _categoryProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'price_low':
          _categoryProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          _categoryProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'name':
          _categoryProducts.sort((a, b) => a.arabicName.compareTo(b.arabicName));
          break;
        case 'newest':
        default:
          _categoryProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Category Header
          _buildSliverAppBar(),

          // Category Info
          _buildCategoryInfo(),

          // Sort and Filter Options
          _buildSortOptions(),

          // Products Grid
          _buildProductsGrid(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.getCategoryColor(widget.category.name),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.category.arabicName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.getCategoryColor(widget.category.name),
                AppColors.getCategoryColor(widget.category.name).withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  _getCategoryIcon(widget.category.name),
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.category.productCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.category.productCount} منتج',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.arabicDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
          ],
        ),
      )
          .animate()
          .slideY(
        begin: 0.3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      )
          .fadeIn(),
    );
  }

  Widget _buildSortOptions() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المنتجات (${_categoryProducts.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _showSortOptions,
                  icon: Icon(Icons.sort, color: AppColors.primary),
                ),
                IconButton(
                  onPressed: _showFilterOptions,
                  icon: Icon(Icons.filter_list, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    if (_isLoading) {
      return const SliverToBoxAdapter(
        child: LoadingWidget(),
      );
    }

    if (_error != null) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 20),
              Text(
                _error!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadCategoryProducts,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_categoryProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 20),
              Text(
                'لا توجد منتجات في هذا القسم',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'سنضيف منتجات جديدة قريباً',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = _categoryProducts[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(product),
            )
                .animate(delay: Duration(milliseconds: 50 + (index % 6 * 25)))
                .slideY(
              begin: 0.3,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            )
                .fadeIn();
          },
          childCount: _categoryProducts.length,
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = [
          {'key': 'newest', 'title': 'الأحدث', 'icon': Icons.new_releases},
          {'key': 'rating', 'title': 'الأعلى تقييماً', 'icon': Icons.star},
          {'key': 'price_low', 'title': 'السعر: من الأقل للأعلى', 'icon': Icons.arrow_upward},
          {'key': 'price_high', 'title': 'السعر: من الأعلى للأقل', 'icon': Icons.arrow_downward},
          {'key': 'name', 'title': 'الاسم (أ-ي)', 'icon': Icons.sort_by_alpha},
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
                final isSelected = _sortBy == option['key'];
                return ListTile(
                  leading: Icon(
                    option['icon'] as IconData,
                    color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                  title: Text('${option['title']!}'),
                  trailing: isSelected
                      ? Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _sortBy = '${option['key']!}';
                    });
                    _applySorting();
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فلترة المنتجات',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Price Range
              Text(
                'نطاق السعر',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // يمكن إضافة slider للسعر هنا

              const SizedBox(height: 20),

              // Brand Filter
              Text(
                'الماركة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // يمكن إضافة قائمة الماركات هنا

              const SizedBox(height: 20),

              // Rating Filter
              Text(
                'التقييم',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // يمكن إضافة فلتر التقييم هنا

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Reset filters
                        Navigator.pop(context);
                      },
                      child: const Text('إعادة تعيين'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters
                        Navigator.pop(context);
                      },
                      child: const Text('تطبيق'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  void _navigateToProductDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}