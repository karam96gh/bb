// lib/logic/providers/product_provider.dart (Fixed excerpt)
import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/services/product_service.dart';
import 'provider_base_mixin.dart';

class ProductProvider extends ChangeNotifier with SafeNotifierMixin {
  // Products State
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _featuredProducts = [];
  List<Category> _categories = [];

  // Loading and Error States
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Filter and Search States
  String _searchQuery = '';
  String? _selectedCategoryId;
  String? _selectedSkinType;
  String _sortBy = 'newest'; // newest, rating, price_low, price_high

  // Pagination
  int _currentPage = 0;
  static const int _pageSize = 20;
  bool _hasMoreProducts = true;

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get featuredProducts => _featuredProducts;
  List<Category> get categories => _categories;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedSkinType => _selectedSkinType;
  String get sortBy => _sortBy;
  bool get hasMoreProducts => _hasMoreProducts;

  // Get category name by ID
  String getCategoryName(String? categoryId) {
    if (categoryId == null) return 'جميع المنتجات';
    final category = _categories.firstWhere(
          (cat) => cat.objectId == categoryId,
      orElse: () => Category(
        objectId: '',
        name: '',
        arabicName: 'غير محدد',
        description: '',
        arabicDescription: '',
        image: '',
        displayOrder: 0,
        isActive: true,
        createdAt: DateTime.now(),
      ),
    );
    return category.arabicName;
  }

  // Initialize provider
  Future<void> initialize() async {
    await Future.wait([
      loadCategories(),
      loadFeaturedProducts(),
      loadProducts(),
    ]);
  }

  // Load all categories
  Future<void> loadCategories() async {
    try {
      _categories = await ProductService.getAllCategories();
      safeNotifyListeners();
    } catch (e) {
      print('❌ Error loading categories: $e');
    }
  }

  // Load featured products
  Future<void> loadFeaturedProducts() async {
    try {
      _featuredProducts = await ProductService.getFeaturedProducts(limit: 10);
      safeNotifyListeners();
    } catch (e) {
      print('❌ Error loading featured products: $e');
    }
  }

  // Load products with filters
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreProducts = true;
      _allProducts.clear();
      _filteredProducts.clear();
    }

    if (_isLoading || !_hasMoreProducts) return;

    _setLoading(true);
    _error = null;

    try {
      final products = await ProductService.getAllProducts(
        limit: _pageSize,
        skip: _currentPage * _pageSize,
        categoryId: _selectedCategoryId,
        skinType: _selectedSkinType,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (products.length < _pageSize) {
        _hasMoreProducts = false;
      }

      if (refresh) {
        _allProducts = products;
      } else {
        _allProducts.addAll(products);
      }

      _applyFiltersAndSort();
      _currentPage++;
    } catch (e) {
      _error = 'خطأ في تحميل المنتجات: $e';
      print('❌ Error loading products: $e');
    }

    _setLoading(false);
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) return;

    _isLoadingMore = true;
    safeNotifyListeners();

    try {
      final products = await ProductService.getAllProducts(
        limit: _pageSize,
        skip: _currentPage * _pageSize,
        categoryId: _selectedCategoryId,
        skinType: _selectedSkinType,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (products.length < _pageSize) {
        _hasMoreProducts = false;
      }

      _allProducts.addAll(products);
      _applyFiltersAndSort();
      _currentPage++;
    } catch (e) {
      print('❌ Error loading more products: $e');
    }

    _isLoadingMore = false;
    safeNotifyListeners();
  }

  // Search products
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    await loadProducts(refresh: true);
  }

  // Filter by category
  Future<void> filterByCategory(String? categoryId) async {
    _selectedCategoryId = categoryId;
    await loadProducts(refresh: true);
  }

  // Filter by skin type
  Future<void> filterBySkinType(String? skinType) async {
    _selectedSkinType = skinType;
    await loadProducts(refresh: true);
  }

  // Sort products
  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
  }

  // Apply filters and sorting
  void _applyFiltersAndSort() {
    _filteredProducts = List.from(_allProducts);

    // Apply sorting
    switch (_sortBy) {
      case 'rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
      default:
        _filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    safeNotifyListeners();
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      // Check if product is already loaded
      final existingProduct = _allProducts.firstWhere(
            (product) => product.objectId == productId,
        orElse: () => Product(
          objectId: '',
          name: '',
          arabicName: '',
          description: '',
          arabicDescription: '',
          categoryId: '',
          brand: '',
          price: 0,
          images: [],
          colors: [],
          skinTypes: [],
          suitableFor: {},
          features: [],
          ingredients: '',
          usage: '',
          benefits: [],
          problemsSolved: [],
          occasion: [],
          finish: '',
          isActive: true,
          stockStatus: '',
          rating: 0,
          reviewsCount: 0,
          createdAt: DateTime.now(),
        ),
      );

      if (existingProduct.objectId.isNotEmpty) {
        return existingProduct;
      }

      // Load from service
      return await ProductService.getProductById(productId);
    } catch (e) {
      print('❌ Error getting product by ID: $e');
      return null;
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      return await ProductService.getProductsByCategory(categoryId);
    } catch (e) {
      print('❌ Error getting products by category: $e');
      return [];
    }
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedSkinType = null;
    _sortBy = 'newest';
    loadProducts(refresh: true);
  }

  // Refresh all data
  Future<void> refresh() async {
    await initialize();
  }

  // Private helper methods (Fixed)
  void _setLoading(bool loading) {
    _isLoading = loading;
    safeNotifyListeners();
  }

  void clearError() {
    _error = null;
    safeNotifyListeners();
  }
}