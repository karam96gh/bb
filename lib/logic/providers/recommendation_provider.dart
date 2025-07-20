import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../../data/models/survey_model.dart';
import '../../data/services/product_service.dart';
import '../../logic/algorithms/recommendation_algorithm.dart';

class RecommendationProvider extends ChangeNotifier {
  // Recommendations State
  List<ProductRecommendation> _recommendations = [];
  List<Product> _recommendedProducts = [];
  bool _isLoading = false;
  String? _error;

  // Analysis State
  Survey? _baseSurvey;
  double _overallConfidence = 0.0;
  Map<String, String> _recommendationReasons = {};

  // Getters
  List<ProductRecommendation> get recommendations => _recommendations;
  List<Product> get recommendedProducts => _recommendedProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Survey? get baseSurvey => _baseSurvey;
  double get overallConfidence => _overallConfidence;
  Map<String, String> get recommendationReasons => _recommendationReasons;

  bool get hasRecommendations => _recommendations.isNotEmpty;
  int get recommendationsCount => _recommendations.length;

  // Get recommendations by category
  List<ProductRecommendation> getRecommendationsByCategory(String categoryName) {
    return _recommendations.where((rec) =>
        rec.product.categoryName.contains(categoryName)).toList();
  }

  // Get high confidence recommendations
  List<ProductRecommendation> get highConfidenceRecommendations =>
      _recommendations.where((rec) => rec.isHighRecommendation).toList();

  // Get medium confidence recommendations
  List<ProductRecommendation> get mediumConfidenceRecommendations =>
      _recommendations.where((rec) => rec.isMediumRecommendation).toList();

  // Generate recommendations based on survey
  Future<void> generateRecommendations(Survey survey) async {
    _setLoading(true);
    _error = null;
    _baseSurvey = survey;

    try {
      // Get all available products
      final allProducts = await ProductService.getAllProducts(limit: 100);

      if (allProducts.isEmpty) {
        _error = 'لم يتم العثور على منتجات';
        _setLoading(false);
        return;
      }

      // Calculate recommendations using algorithm
      _recommendations = RecommendationAlgorithm.calculateRecommendations(
        allProducts,
        survey,
      );

      // Extract recommended products
      _recommendedProducts = _recommendations.map((rec) => rec.product).toList();

      // Calculate overall confidence
      _calculateOverallConfidence();

      // Generate reason summaries
      _generateReasonSummaries();

      print('✅ Generated ${_recommendations.length} recommendations');
    } catch (e) {
      _error = 'خطأ في توليد التوصيات: $e';
      print('❌ Error generating recommendations: $e');
    }

    _setLoading(false);
  }

  // Generate recommendations for specific skin type
  Future<void> generateRecommendationsForSkinType(String skinType) async {
    _setLoading(true);
    _error = null;

    try {
      // Get products suitable for skin type
      final products = await ProductService.getAllProducts(
        skinType: skinType,
        limit: 50,
      );

      // Create a simple survey-like object for skin type
      final simpleSurvey = Survey(
        objectId: '',
        userId: '',
        answers: {},
        skinAnalysis: {skinType: 100.0},
        problemsAnalysis: {},
        preferencesAnalysis: {},
        finalSkinType: skinType,
        confidenceScore: 1.0,
        recommendations: [],
        recommendationScores: {},
        completedAt: DateTime.now(),
        isActive: true,
      );

      _recommendations = RecommendationAlgorithm.calculateRecommendations(
        products,
        simpleSurvey,
      );

      _recommendedProducts = _recommendations.map((rec) => rec.product).toList();
      _calculateOverallConfidence();
      _generateReasonSummaries();

    } catch (e) {
      _error = 'خطأ في توليد التوصيات لنوع البشرة: $e';
      print('❌ Error generating recommendations for skin type: $e');
    }

    _setLoading(false);
  }

  // Get recommendations by product type
  Future<void> getRecommendationsByProductType(String productType, {
    String? skinType,
    Map<String, dynamic>? preferences,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Get products by category
      String? categoryId;
      switch (productType.toLowerCase()) {
        case 'lipstick':
        case 'أحمر شفاه':
        // Find lipstick category ID
          final categories = await ProductService.getAllCategories();
          final lipstickCategory = categories.firstWhere(
                (cat) => cat.name.toLowerCase().contains('lipstick'),
            orElse: () => categories.first,
          );
          categoryId = lipstickCategory.objectId;
          break;
        case 'mascara':
        case 'مسكرة':
          final categories = await ProductService.getAllCategories();
          final mascaraCategory = categories.firstWhere(
                (cat) => cat.name.toLowerCase().contains('mascara'),
            orElse: () => categories.first,
          );
          categoryId = mascaraCategory.objectId;
          break;
      }

      final products = await ProductService.getAllProducts(
        categoryId: categoryId,
        skinType: skinType,
        limit: 30,
      );

      // Create a basic survey for this type
      final survey = Survey(
        objectId: '',
        userId: '',
        answers: {},
        skinAnalysis: skinType != null ? {skinType: 100.0} : {},
        problemsAnalysis: {},
        preferencesAnalysis: preferences ?? {},
        finalSkinType: skinType ?? 'normal',
        confidenceScore: 0.8,
        recommendations: [],
        recommendationScores: {},
        completedAt: DateTime.now(),
        isActive: true,
      );

      _recommendations = RecommendationAlgorithm.calculateRecommendations(
        products,
        survey,
      );

      _recommendedProducts = _recommendations.map((rec) => rec.product).toList();
      _calculateOverallConfidence();
      _generateReasonSummaries();

    } catch (e) {
      _error = 'خطأ في الحصول على توصيات نوع المنتج: $e';
      print('❌ Error getting recommendations by product type: $e');
    }

    _setLoading(false);
  }

  // Get product recommendation details
  ProductRecommendation? getProductRecommendation(String productId) {
    try {
      return _recommendations.firstWhere(
            (rec) => rec.product.objectId == productId,
      );
    } catch (e) {
      return null;
    }
  }

  // Update recommendation after user feedback
  void updateRecommendationFeedback(String productId, bool liked) {
    final index = _recommendations.indexWhere(
          (rec) => rec.product.objectId == productId,
    );

    if (index != -1) {
      // Here you could implement learning from user feedback
      // For now, we'll just adjust the score slightly
      final currentRec = _recommendations[index];
      final adjustedScore = liked
          ? (currentRec.score * 1.1).clamp(0.0, 100.0)
          : (currentRec.score * 0.9).clamp(0.0, 100.0);

      _recommendations[index] = ProductRecommendation(
        product: currentRec.product,
        score: adjustedScore,
        reasons: currentRec.reasons,
        confidence: currentRec.confidence,
      );

      // Re-sort recommendations
      _recommendations.sort((a, b) => b.score.compareTo(a.score));
      notifyListeners();
    }
  }

  // Filter recommendations by minimum score
  List<ProductRecommendation> getFilteredRecommendations({
    double minScore = 60.0,
    int? limit,
  }) {
    var filtered = _recommendations.where((rec) => rec.score >= minScore).toList();
    if (limit != null && limit > 0) {
      filtered = filtered.take(limit).toList();
    }
    return filtered;
  }

  // Get recommendation explanation
  String getRecommendationExplanation(String productId) {
    final recommendation = getProductRecommendation(productId);
    if (recommendation == null) return '';

    String explanation = 'نوصي بهذا المنتج لأنه:\n';
    for (int i = 0; i < recommendation.reasons.length; i++) {
      explanation += '• ${recommendation.reasons[i]}\n';
    }
    explanation += '\nنسبة التوافق: ${recommendation.scorePercentage}';
    explanation += '\nمستوى الثقة: ${recommendation.confidencePercentage}';

    return explanation;
  }

  // Calculate overall confidence
  void _calculateOverallConfidence() {
    if (_recommendations.isEmpty) {
      _overallConfidence = 0.0;
      return;
    }

    double totalConfidence = 0.0;
    for (var rec in _recommendations) {
      totalConfidence += rec.confidence;
    }
    _overallConfidence = totalConfidence / _recommendations.length;
  }

  // Generate reason summaries
  void _generateReasonSummaries() {
    _recommendationReasons.clear();

    for (var rec in _recommendations) {
      _recommendationReasons[rec.product.objectId] =
          rec.reasons.join(' • ');
    }
  }

  // Clear recommendations
  void clearRecommendations() {
    _recommendations.clear();
    _recommendedProducts.clear();
    _baseSurvey = null;
    _overallConfidence = 0.0;
    _recommendationReasons.clear();
    _error = null;
    notifyListeners();
  }

  // Refresh recommendations
  Future<void> refreshRecommendations() async {
    if (_baseSurvey != null) {
      await generateRecommendations(_baseSurvey!);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
