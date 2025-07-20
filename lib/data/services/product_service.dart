import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import 'back4app_service.dart';
import '../../core/constants/app_constants.dart';

class ProductService {
  // Get all products
  static Future<List<Product>> getAllProducts({
    int limit = 20,
    int skip = 0,
    String? categoryId,
    String? skinType,
    String? searchQuery,
  }) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.productsTable);

      // Include category information
      query.includeObject(['category']);

      // Filter by category
      if (categoryId != null && categoryId.isNotEmpty) {
        query.whereEqualTo('category', ParseObject(AppConstants.categoriesTable)..objectId = categoryId);
      }

      // Filter by skin type
      if (skinType != null && skinType.isNotEmpty) {
        query.whereContains('skinTypes', skinType);
      }

      // Search functionality
      if (searchQuery != null && searchQuery.isNotEmpty) {

        query.whereContains('arabicName', searchQuery);



      }

      // Only active products
      query.whereEqualTo('isActive', true);

      // Pagination and ordering
      query.setLimit(limit);
      query.setAmountToSkip(skip);
      query.orderByDescending('createdAt');

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => Product.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting products: $e');
      return [];
    }
  }

  // Get product by ID
  static Future<Product?> getProductById(String productId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.productsTable);
      query.includeObject(['category']);
      query.whereEqualTo('objectId', productId);

      final results = await Back4AppService.queryWithConditions(query);
      if (results.isNotEmpty) {
        return Product.fromJson(results.first.toJson());
      }
      return null;
    } catch (e) {
      print('❌ Error getting product by ID: $e');
      return null;
    }
  }

  // Get products by IDs (for recommendations)
  static Future<List<Product>> getProductsByIds(List<String> productIds) async {
    try {
      if (productIds.isEmpty) return [];

      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.productsTable);
      query.includeObject(['category']);
      query.whereContainedIn('objectId', productIds);
      query.whereEqualTo('isActive', true);

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => Product.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting products by IDs: $e');
      return [];
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(String categoryId, {
    int limit = 20,
    int skip = 0,
  }) async {
    return getAllProducts(
      categoryId: categoryId,
      limit: limit,
      skip: skip,
    );
  }

  // Get featured products (high rating)
  static Future<List<Product>> getFeaturedProducts({int limit = 10}) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.productsTable);
      query.includeObject(['category']);
      query.whereEqualTo('isActive', true);
      query.whereGreaterThan('rating', 4.0);
      query.orderByDescending('rating');
      query.setLimit(limit);

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => Product.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting featured products: $e');
      return [];
    }
  }

  // Get all categories
  static Future<List<Category>> getAllCategories() async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.categoriesTable);
      query.whereEqualTo('isActive', true);
      query.orderByAscending('displayOrder');

      final results = await Back4AppService.queryWithConditions(query);
      List<Category> categories = results.map((result) => Category.fromJson(result.toJson())).toList();

      // Get product count for each category
      for (var category in categories) {
        category.productCount = await getProductCountByCategory(category.objectId);
      }

      return categories;
    } catch (e) {
      print('❌ Error getting categories: $e');
      return [];
    }
  }

  // Get product count by category
  static Future<int> getProductCountByCategory(String categoryId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.productsTable);
      query.whereEqualTo('category', ParseObject(AppConstants.categoriesTable)..objectId = categoryId);
      query.whereEqualTo('isActive', true);

      return await Back4AppService.count(AppConstants.productsTable, query: query);
    } catch (e) {
      print('❌ Error getting product count: $e');
      return 0;
    }
  }

  // Search products
  static Future<List<Product>> searchProducts(String searchQuery, {
    int limit = 20,
    String? categoryId,
  }) async {
    return getAllProducts(
      searchQuery: searchQuery,
      categoryId: categoryId,
      limit: limit,
    );
  }
}