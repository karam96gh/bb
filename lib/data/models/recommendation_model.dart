// lib/data/models/recommendation_model.dart
import '../../../core/utils/calculation_utils.dart';
import 'product_model.dart';
import 'survey_model.dart';

class ProductRecommendation {
  final Product product;
  final double score;
  final List<String> reasons;
  final double confidence;
  final Map<String, dynamic> detailedAnalysis;
  final DateTime generatedAt;

  ProductRecommendation({
    required this.product,
    required this.score,
    required this.reasons,
    required this.confidence,
    this.detailedAnalysis = const {},
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      product: Product.fromJson(json['product'] ?? {}),
      score: CalculationUtils.safeDoubleFromDynamic(json['score']),
      reasons: List<String>.from(json['reasons'] ?? []),
      confidence: CalculationUtils.safeDoubleFromDynamic(json['confidence']),
      detailedAnalysis: Map<String, dynamic>.from(json['detailedAnalysis'] ?? {}),
      generatedAt: DateTime.tryParse(json['generatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'score': score,
      'reasons': reasons,
      'confidence': confidence,
      'detailedAnalysis': detailedAnalysis,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  // Helper getters
  String get scorePercentage => '${score.toInt()}%';
  String get confidencePercentage => '${(confidence * 100).toInt()}%';

  bool get isHighRecommendation => score >= 80;
  bool get isMediumRecommendation => score >= 60 && score < 80;
  bool get isLowRecommendation => score < 60;

  bool get isHighConfidence => confidence >= 0.8;
  bool get isMediumConfidence => confidence >= 0.6 && confidence < 0.8;
  bool get isLowConfidence => confidence < 0.6;

  String get recommendationLevel {
    if (isHighRecommendation) return 'موصى بشدة';
    if (isMediumRecommendation) return 'موصى به';
    return 'قد يناسبك';
  }

  String get confidenceLevel {
    if (isHighConfidence) return 'عالية';
    if (isMediumConfidence) return 'متوسطة';
    return 'منخفضة';
  }

  // Get primary reason for recommendation
  String get primaryReason => reasons.isNotEmpty ? reasons.first : 'موصى به لك';

  // Get all reasons as formatted string
  String get allReasonsText => reasons.join(' • ');

  // Copy with method
  ProductRecommendation copyWith({
    Product? product,
    double? score,
    List<String>? reasons,
    double? confidence,
    Map<String, dynamic>? detailedAnalysis,
    DateTime? generatedAt,
  }) {
    return ProductRecommendation(
      product: product ?? this.product,
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
      confidence: confidence ?? this.confidence,
      detailedAnalysis: detailedAnalysis ?? this.detailedAnalysis,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}

class RecommendationEngine {
  // Generate recommendations based on survey
  static List<ProductRecommendation> generateRecommendations(
      List<Product> products,
      Survey survey,
      ) {
    final recommendations = <ProductRecommendation>[];

    for (final product in products) {
      final analysis = _analyzeProductForUser(product, survey);

      if (analysis['score'] >= 50) { // Minimum threshold
        recommendations.add(ProductRecommendation(
          product: product,
          score: analysis['score'],
          reasons: List<String>.from(analysis['reasons']),
          confidence: analysis['confidence'],
          detailedAnalysis: analysis,
        ));
      }
    }

    // Sort by score (highest first)
    recommendations.sort((a, b) => b.score.compareTo(a.score));

    return recommendations;
  }

  // Analyze how well a product matches user needs
  static Map<String, dynamic> _analyzeProductForUser(
      Product product,
      Survey survey,
      ) {
    double totalScore = 0.0;
    double totalWeight = 0.0;
    final reasons = <String>[];
    final analysis = <String, dynamic>{};

    // 1. Skin Type Compatibility (40% weight)
    final skinTypeAnalysis = _analyzeSkinTypeCompatibility(product, survey);
    totalScore += skinTypeAnalysis['score'] * 0.4;
    totalWeight += 0.4;
    if (skinTypeAnalysis['reasons'].isNotEmpty) {
      reasons.addAll(List<String>.from(skinTypeAnalysis['reasons']));
    }
    analysis['skinTypeCompatibility'] = skinTypeAnalysis;

    // 2. Problem Solving (30% weight)
    final problemAnalysis = _analyzeProblemSolving(product, survey);
    totalScore += problemAnalysis['score'] * 0.3;
    totalWeight += 0.3;
    if (problemAnalysis['reasons'].isNotEmpty) {
      reasons.addAll(List<String>.from(problemAnalysis['reasons']));
    }
    analysis['problemSolving'] = problemAnalysis;

    // 3. Preference Matching (20% weight)
    final preferenceAnalysis = _analyzePreferenceMatching(product, survey);
    totalScore += preferenceAnalysis['score'] * 0.2;
    totalWeight += 0.2;
    if (preferenceAnalysis['reasons'].isNotEmpty) {
      reasons.addAll(List<String>.from(preferenceAnalysis['reasons']));
    }
    analysis['preferenceMatching'] = preferenceAnalysis;

    // 4. Product Quality (10% weight)
    final qualityAnalysis = _analyzeProductQuality(product);
    totalScore += qualityAnalysis['score'] * 0.1;
    totalWeight += 0.1;
    if (qualityAnalysis['reasons'].isNotEmpty) {
      reasons.addAll(List<String>.from(qualityAnalysis['reasons']));
    }
    analysis['productQuality'] = qualityAnalysis;

    final finalScore = totalWeight > 0 ? totalScore / totalWeight * 100 : 0.0;
    final confidence = _calculateConfidence(analysis, survey);

    return {
      'score': finalScore.clamp(0.0, 100.0),
      'reasons': reasons.take(3).toList(), // Top 3 reasons
      'confidence': confidence,
      'breakdown': analysis,
    };
  }

  static Map<String, dynamic> _analyzeSkinTypeCompatibility(
      Product product,
      Survey survey,
      ) {
    double score = 50.0; // Base score
    final reasons = <String>[];

    // Check if product is suitable for user's skin type
    final userSkinType = survey.finalSkinType;
    if (product.skinTypes.contains(userSkinType)) {
      score += 30;
      reasons.add('مناسب لنوع بشرتك');
    }

    // Check suitability score from product data
    final suitabilityScore = product.getSuitabilityScore(userSkinType);
    if (suitabilityScore > 0) {
      score += (suitabilityScore / 100) * 20;
      if (suitabilityScore >= 80) {
        reasons.add('مثالي لبشرتك');
      }
    }

    // Analyze skin analysis results
    survey.skinAnalysis.forEach((skinType, confidence) {
      if (product.skinTypes.contains(skinType) && confidence > 0.3) {
        score += confidence * 10;
      }
    });

    return {
      'score': score.clamp(0.0, 100.0),
      'reasons': reasons,
      'userSkinType': userSkinType,
      'productSkinTypes': product.skinTypes,
      'suitabilityScore': suitabilityScore,
    };
  }

  static Map<String, dynamic> _analyzeProblemSolving(
      Product product,
      Survey survey,
      ) {
    double score = 50.0;
    final reasons = <String>[];
    final problems = survey.problemsAnalysis;

    // Check for moisturizing needs
    if (problems['needsMoisturizing'] == true) {
      if (product.features.contains('moisturizing') ||
          product.ingredients.contains('مرطب') ||
          product.name.toLowerCase().contains('balm')) {
        score += 25;
        reasons.add('يوفر الترطيب المطلوب');
      }
    }

    // Check for long-lasting needs
    if (problems['needsLongLasting'] == true) {
      if (product.features.contains('long_lasting') ||
          product.features.contains('smudge_proof') ||
          product.finish == 'matte') {
        score += 25;
        reasons.add('ثبات طويل الأمد');
      }
    }

    // Check for environmental protection
    if (problems['needsEnvironmentalProtection'] == true) {
      if (product.features.contains('water_resistant') ||
          product.features.contains('transfer_resistant')) {
        score += 20;
        reasons.add('مقاوم للعوامل البيئية');
      }
    }

    // Check problems solved by product
    final problemsSolved = product.problemsSolved;
    int solvedCount = 0;
    for (final problem in problemsSolved) {
      if (problems.containsKey(problem) && problems[problem] == true) {
        solvedCount++;
        score += 15;
      }
    }

    if (solvedCount > 0) {
      reasons.add('يحل ${solvedCount} من مشاكلك');
    }

    return {
      'score': score.clamp(0.0, 100.0),
      'reasons': reasons,
      'problemsSolved': solvedCount,
      'userProblems': problems,
      'productSolutions': problemsSolved,
    };
  }

  static Map<String, dynamic> _analyzePreferenceMatching(
      Product product,
      Survey survey,
      ) {
    double score = 50.0;
    final reasons = <String>[];
    final preferences = survey.preferencesAnalysis;

    // Product type preference
    final productType = preferences['productType'];
    if (productType != null) {
      score += _scoreProductTypeMatch(product, productType);
    }

    // Texture preference
    final texturePreference = preferences['texturePreference'];
    if (texturePreference != null) {
      final textureScore = _scoreTextureMatch(product, texturePreference);
      score += textureScore;
      if (textureScore > 15) {
        reasons.add('ملمس مناسب لتفضيلاتك');
      }
    }

    // Color preference
    final colorPreference = preferences['colorPreference'];
    if (colorPreference != null && product.colors.isNotEmpty) {
      final colorScore = _scoreColorMatch(product, colorPreference);
      score += colorScore;
      if (colorScore > 10) {
        reasons.add('ألوان تناسب ذوقك');
      }
    }

    // Occasion preference
    final occasionPreference = preferences['occasionPreference'];
    if (occasionPreference != null) {
      final occasionScore = _scoreOccasionMatch(product, occasionPreference);
      score += occasionScore;
      if (occasionScore > 10) {
        reasons.add('مناسب للمناسبات المفضلة');
      }
    }

    return {
      'score': score.clamp(0.0, 100.0),
      'reasons': reasons,
      'userPreferences': preferences,
      'productAttributes': {
        'finish': product.finish,
        'occasion': product.occasion,
        'colors': product.colors.length,
      },
    };
  }

  static Map<String, dynamic> _analyzeProductQuality(Product product) {
    double score = 50.0;
    final reasons = <String>[];

    // Rating score
    if (product.rating > 0) {
      score += (product.rating / 5.0) * 30;
      if (product.rating >= 4.5) {
        reasons.add('تقييم ممتاز (${product.ratingText})');
      } else if (product.rating >= 4.0) {
        reasons.add('تقييم جيد جداً');
      }
    }

    // Review count
    if (product.reviewsCount > 50) {
      score += 10;
      if (product.reviewsCount > 100) {
        reasons.add('مجرب من قبل العديد من المستخدمين');
      }
    }

    // Stock availability
    if (product.isInStock) {
      score += 10;
    } else {
      score -= 20;
      reasons.add('غير متوفر حالياً');
    }

    return {
      'score': score.clamp(0.0, 100.0),
      'reasons': reasons,
      'rating': product.rating,
      'reviewsCount': product.reviewsCount,
      'inStock': product.isInStock,
    };
  }

  static double _scoreProductTypeMatch(Product product, String productType) {
    switch (productType) {
      case 'daily_lipstick':
        if (product.categoryName.contains('شفاه') &&
            (product.finish == 'natural' || product.name.contains('Balm'))) {
          return 20.0;
        }
        break;
      case 'evening_lipstick':
        if (product.categoryName.contains('شفاه') &&
            (product.finish == 'matte' || product.name.contains('Infallible'))) {
          return 20.0;
        }
        break;
      case 'volume_mascara':
        if (product.categoryName.contains('مسكرة') &&
            product.name.contains('Paradise')) {
          return 20.0;
        }
        break;
      case 'dramatic_mascara':
        if (product.categoryName.contains('مسكرة') &&
            product.name.contains('Carbon Black')) {
          return 20.0;
        }
        break;
      case 'lip_balm':
        if (product.name.contains('Balm') || product.name.contains('Paradise')) {
          return 20.0;
        }
        break;
    }
    return 5.0; // Base score for any match
  }

  static double _scoreTextureMatch(Product product, String texturePreference) {
    switch (texturePreference) {
      case 'long_lasting':
        if (product.features.contains('long_lasting') ||
            product.name.contains('Infallible')) {
          return 20.0;
        }
        break;
      case 'moisturizing':
        if (product.features.contains('moisturizing') ||
            product.name.contains('Balm') ||
            product.name.contains('Shine')) {
          return 20.0;
        }
        break;
      case 'glossy':
        if (product.finish == 'glossy' || product.name.contains('Shine')) {
          return 20.0;
        }
        break;
      case 'balanced':
        if (product.finish == 'natural') {
          return 15.0;
        }
        break;
    }
    return 5.0;
  }

  static double _scoreColorMatch(Product product, String colorPreference) {
    switch (colorPreference) {
      case 'natural':
      // Check for nude/beige colors
        final hasNaturalColors = product.colors.any((color) =>
        color.name.toLowerCase().contains('nude') ||
            color.name.toLowerCase().contains('beige') ||
            color.arabicName.contains('بيج'));
        return hasNaturalColors ? 15.0 : 5.0;
      case 'bold':
      // Check for bold colors
        final hasBoldColors = product.colors.any((color) =>
        color.name.toLowerCase().contains('red') ||
            color.name.toLowerCase().contains('deep') ||
            color.arabicName.contains('غامق'));
        return hasBoldColors ? 15.0 : 5.0;
      case 'varied':
      // More colors = better for varied preference
        return (product.colors.length * 3.0).clamp(0.0, 15.0);
      default:
        return 10.0;
    }
  }

  static double _scoreOccasionMatch(Product product, String occasionPreference) {
    switch (occasionPreference) {
      case 'professional':
        if (product.occasion.contains('professional') ||
            product.finish == 'matte') {
          return 15.0;
        }
        break;
      case 'social':
      case 'special_events':
        if (product.occasion.contains('evening') ||
            product.name.contains('Carbon Black') ||
            product.finish == 'glossy') {
          return 15.0;
        }
        break;
      case 'daily':
        if (product.occasion.contains('daily') ||
            product.name.contains('Paradise')) {
          return 15.0;
        }
        break;
      case 'night_care':
        if (product.name.contains('Balm')) {
          return 15.0;
        }
        break;
    }
    return 5.0;
  }

  static double _calculateConfidence(
      Map<String, dynamic> analysis,
      Survey survey,
      ) {
    double confidence = survey.confidenceScore;

    // Adjust confidence based on analysis completeness
    final skinTypeAnalysis = analysis['skinTypeCompatibility'];
    final problemAnalysis = analysis['problemSolving'];
    final preferenceAnalysis = analysis['preferenceMatching'];
    final qualityAnalysis = analysis['productQuality'];

    // Higher confidence if multiple factors align
    int alignedFactors = 0;
    if (skinTypeAnalysis['score'] > 70) alignedFactors++;
    if (problemAnalysis['score'] > 70) alignedFactors++;
    if (preferenceAnalysis['score'] > 70) alignedFactors++;
    if (qualityAnalysis['score'] > 70) alignedFactors++;

    // Boost confidence based on alignment
    confidence += (alignedFactors / 4.0) * 0.2;

    // Cap confidence
    return confidence.clamp(0.5, 1.0);
  }
}

// Recommendation categories
enum RecommendationCategory {
  lipstick,
  mascara,
  lipBalm,
  skincare,
  all,
}

extension RecommendationCategoryExtension on RecommendationCategory {
  String get displayName {
    switch (this) {
      case RecommendationCategory.lipstick:
        return 'أحمر الشفاه';
      case RecommendationCategory.mascara:
        return 'المسكرة';
      case RecommendationCategory.lipBalm:
        return 'بلسم الشفاه';
      case RecommendationCategory.skincare:
        return 'العناية بالبشرة';
      case RecommendationCategory.all:
        return 'جميع المنتجات';
    }
  }

  String get categoryKey {
    switch (this) {
      case RecommendationCategory.lipstick:
        return 'lipstick';
      case RecommendationCategory.mascara:
        return 'mascara';
      case RecommendationCategory.lipBalm:
        return 'lip_balm';
      case RecommendationCategory.skincare:
        return 'skincare';
      case RecommendationCategory.all:
        return 'all';
    }
  }
}

// Recommendation filters
class RecommendationFilters {
  final RecommendationCategory? category;
  final double? minScore;
  final double? minConfidence;
  final String? skinType;
  final List<String>? brands;
  final double? maxPrice;
  final double? minPrice;

  const RecommendationFilters({
    this.category,
    this.minScore,
    this.minConfidence,
    this.skinType,
    this.brands,
    this.maxPrice,
    this.minPrice,
  });

  RecommendationFilters copyWith({
    RecommendationCategory? category,
    double? minScore,
    double? minConfidence,
    String? skinType,
    List<String>? brands,
    double? maxPrice,
    double? minPrice,
  }) {
    return RecommendationFilters(
      category: category ?? this.category,
      minScore: minScore ?? this.minScore,
      minConfidence: minConfidence ?? this.minConfidence,
      skinType: skinType ?? this.skinType,
      brands: brands ?? this.brands,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
    );
  }

  bool matches(ProductRecommendation recommendation) {
    final product = recommendation.product;

    // Category filter
    if (category != null && category != RecommendationCategory.all) {
      final categoryMatches = _categoryMatches(product, category!);
      if (!categoryMatches) return false;
    }

    // Score filter
    if (minScore != null && recommendation.score < minScore!) {
      return false;
    }

    // Confidence filter
    if (minConfidence != null && recommendation.confidence < minConfidence!) {
      return false;
    }

    // Skin type filter
    if (skinType != null && !product.skinTypes.contains(skinType)) {
      return false;
    }

    // Brand filter
    if (brands != null && brands!.isNotEmpty && !brands!.contains(product.brand)) {
      return false;
    }

    // Price filter
    if (minPrice != null && product.price < minPrice!) {
      return false;
    }
    if (maxPrice != null && product.price > maxPrice!) {
      return false;
    }

    return true;
  }

  bool _categoryMatches(Product product, RecommendationCategory category) {
    switch (category) {
      case RecommendationCategory.lipstick:
        return product.categoryName.contains('شفاه') &&
            !product.name.contains('Balm');
      case RecommendationCategory.mascara:
        return product.categoryName.contains('مسكرة');
      case RecommendationCategory.lipBalm:
        return product.name.contains('Balm') ||
            product.categoryName.contains('بلسم');
      case RecommendationCategory.skincare:
        return product.categoryName.contains('عناية');
      case RecommendationCategory.all:
        return true;
    }
  }
}