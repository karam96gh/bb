// lib/presentation/screens/products/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (_currentQuery.isEmpty) {
            return _buildEmptyState();
          }

          if (productProvider.isLoading) {
            return const LoadingWidget();
          }

          if (productProvider.filteredProducts.isEmpty) {
            return _buildNoResultsState();
          }

          return _buildSearchResults(productProvider);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'ابحثي عن منتجك المفضل...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            onPressed: _clearSearch,
            icon: Icon(Icons.clear, color: AppColors.onSurfaceVariant),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),

          Icon(
            Icons.search,
            size: 80,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          )
              .animate()
              .scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 24),

          Text(
            'ابحثي عن منتجك المفضل',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn()
              .slideY(begin: 0.3, curve: Curves.easeOut),

          const SizedBox(height: 12),

          Text(
            'يمكنك البحث باسم المنتج أو الماركة أو نوع المنتج',
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

          // Popular searches
          _buildPopularSearches(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      'أحمر شفاه',
      'مسكرة',
      'بلسم شفاه',
      'لوريال',
      'مات',
      'لامع',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البحث الشائع',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.map((search) {
            return GestureDetector(
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  search,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 600))
        .fadeIn()
        .slideY(begin: 0.3, curve: Curves.easeOut);
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),

          const SizedBox(height: 24),

          Text(
            'لا توجد نتائج',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'لم نجد أي منتجات تطابق بحثك عن "$_currentQuery"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          OutlinedButton(
            onPressed: _clearSearch,
            child: const Text('مسح البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ProductProvider productProvider) {
    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'النتائج (${productProvider.filteredProducts.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showFilterOptions(productProvider),
                icon: Icon(Icons.filter_list, size: 20),
                label: Text('فلترة'),
              ),
            ],
          ),
        ),

        // Results grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: productProvider.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = productProvider.filteredProducts[index];
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
          ),
        ),
      ],
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentQuery = value;
    });

    if (value.isNotEmpty) {
      context.read<ProductProvider>().searchProducts(value);
    }
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    context.read<ProductProvider>().clearFilters();
  }

  void _showFilterOptions(ProductProvider productProvider) {
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
                'فلترة النتائج',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Category filter
              Text(
                'الفئة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: productProvider.categories.map((category) {
                  final isSelected = productProvider.selectedCategoryId == category.objectId;
                  return FilterChip(
                    label: Text(category.arabicName),
                    selected: isSelected,
                    onSelected: (selected) {
                      productProvider.filterByCategory(
                        selected ? category.objectId : null,
                      );
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProductDetail(product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}


