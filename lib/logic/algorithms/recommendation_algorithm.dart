// lib/logic/algorithms/recommendation_algorithm.dart
import '../../data/models/product_model.dart';
import '../../data/models/survey_model.dart';
import '../../core/constants/app_constants.dart';

class RecommendationAlgorithm {
  // نقاط التوافق للمنتجات حسب نوع البشرة
  static final Map<String, Map<String, int>> _productSkinTypeMatrix = {
    "L'Oréal Color Riche Matte Lipstick": {
      AppConstants.oilySkin: 90,
      AppConstants.drySkin: 80,
      AppConstants.combinationSkin: 95,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 90,
    },
    "L'Oréal Infallible Pro-Matte Liquid Lipstick": {
      AppConstants.oilySkin: 95,
      AppConstants.drySkin: 65,
      AppConstants.combinationSkin: 90,
      AppConstants.sensitiveSkin: 70,
      AppConstants.normalSkin: 85,
    },
    "L'Oréal Color Riche Shine Lipstick": {
      AppConstants.oilySkin: 70,
      AppConstants.drySkin: 90,
      AppConstants.combinationSkin: 80,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 90,
    },
    "L'Oréal Glow Paradise Balm-in-Lipstick": {
      AppConstants.oilySkin: 75,
      AppConstants.drySkin: 95,
      AppConstants.combinationSkin: 85,
      AppConstants.sensitiveSkin: 98,
      AppConstants.normalSkin: 95,
    },
    "L'Oréal Voluminous Lash Paradise Mascara": {
      AppConstants.oilySkin: 85,
      AppConstants.drySkin: 85,
      AppConstants.combinationSkin: 85,
      AppConstants.sensitiveSkin: 80,
      AppConstants.normalSkin: 90,
    },
    "L'Oréal Telescopic Mascara": {
      AppConstants.oilySkin: 90,
      AppConstants.drySkin: 80,
      AppConstants.combinationSkin: 85,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 95,
    },
    "L'Oréal Voluminous Carbon Black Mascara": {
      AppConstants.oilySkin: 85,
      AppConstants.drySkin: 75,
      AppConstants.combinationSkin: 80,
      AppConstants.sensitiveSkin: 75,
      AppConstants.normalSkin: 85,
    },
    "L'Oréal True Match Foundation": {
      AppConstants.oilySkin: 75,
      AppConstants.drySkin: 90,
      AppConstants.combinationSkin: 95,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 92,
    },
    "Maybelline Fit Me Matte Foundation": {
      AppConstants.oilySkin: 95,
      AppConstants.drySkin: 65,
      AppConstants.combinationSkin: 90,
      AppConstants.sensitiveSkin: 75,
      AppConstants.normalSkin: 80,
    },
    "MAC Studio Fix Fluid Foundation": {
      AppConstants.oilySkin: 92,
      AppConstants.drySkin: 70,
      AppConstants.combinationSkin: 88,
      AppConstants.sensitiveSkin: 80,
      AppConstants.normalSkin: 85,
    },

    // === منتجات أحمر الخدود الجديدة ===
    "NARS Orgasm Blush": {
      AppConstants.oilySkin: 88,
      AppConstants.drySkin: 92,
      AppConstants.combinationSkin: 90,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 95,
    },
    "Milani Baked Blush Luminoso": {
      AppConstants.oilySkin: 80,
      AppConstants.drySkin: 90,
      AppConstants.combinationSkin: 85,
      AppConstants.sensitiveSkin: 88,
      AppConstants.normalSkin: 92,
    },
    "Tarte Amazonian Clay Blush": {
      AppConstants.oilySkin: 95,
      AppConstants.drySkin: 80,
      AppConstants.combinationSkin: 92,
      AppConstants.sensitiveSkin: 85,
      AppConstants.normalSkin: 88,
    },

    // === منتجات البرونزر الجديدة ===
    "Benefit Hoola Matte Bronzer": {
      AppConstants.oilySkin: 90,
      AppConstants.drySkin: 85,
      AppConstants.combinationSkin: 88,
      AppConstants.sensitiveSkin: 82,
      AppConstants.normalSkin: 92,
    },
    "Physicians Formula Butter Bronzer": {
      AppConstants.oilySkin: 75,
      AppConstants.drySkin: 95,
      AppConstants.combinationSkin: 82,
      AppConstants.sensitiveSkin: 90,
      AppConstants.normalSkin: 88,
    },
    "Too Faced Chocolate Soleil Bronzer": {
      AppConstants.oilySkin: 88,
      AppConstants.drySkin: 80,
      AppConstants.combinationSkin: 85,
      AppConstants.sensitiveSkin: 78,
      AppConstants.normalSkin: 90,
    },
  };

  // حساب توصيات المنتجات
  static List<ProductRecommendation> calculateRecommendations(
      List<Product> allProducts,
      Survey survey,
      ) {
    List<ProductRecommendation> recommendations = [];

    for (var product in allProducts) {
      final score = _calculateProductScore(product, survey);
      if (score > 50) { // حد أدنى للتوصية
        recommendations.add(ProductRecommendation(
          product: product,
          score: score,
          reasons: _generateRecommendationReasons(product, survey),
          confidence: _calculateRecommendationConfidence(product, survey),
        ));
      }
    }

    // ترتيب حسب النقاط
    recommendations.sort((a, b) => b.score.compareTo(a.score));

    // أخذ أفضل 5 توصيات
    return recommendations.take(5).toList();
  }

  // حساب نقاط المنتج
  static double _calculateProductScore(Product product, Survey survey) {
    double totalScore = 0.0;

    // 1. نقاط نوع البشرة (40%)
    final skinTypeScore = _calculateSkinTypeScore(product, survey);
    totalScore += skinTypeScore * 0.4;

    // 2. نقاط المشاكل والاحتياجات (30%)
    final problemsScore = _calculateProblemsScore(product, survey);
    totalScore += problemsScore * 0.3;

    // 3. نقاط التفضيلات (30%)
    final preferencesScore = _calculatePreferencesScore(product, survey);
    totalScore += preferencesScore * 0.3;

    return totalScore.clamp(0.0, 100.0);
  }

  // حساب نقاط نوع البشرة
  static double _calculateSkinTypeScore(Product product, Survey survey) {
    final productMatrix = _productSkinTypeMatrix[product.name];
    if (productMatrix == null) {
      // استخدام النقاط من قاعدة البيانات
      return product.getSuitabilityScore(survey.finalSkinType).toDouble();
    }

    double weightedScore = 0.0;
    double totalWeight = 0.0;

    survey.skinAnalysis.forEach((skinType, confidence) {
      final productScore = productMatrix[skinType] ?? 0;
      weightedScore += productScore * confidence;
      totalWeight += confidence;
    });

    return totalWeight > 0 ? weightedScore / totalWeight : 0.0;
  }

  // حساب نقاط المشاكل
  static double _calculateProblemsScore(Product product, Survey survey) {
    double score = 60.0; // نقطة أساسية

    final problems = survey.problemsAnalysis;

    // التحقق من حل المشاكل المحددة
    if (problems['needsMoisturizing'] == true) {
      if (product.features.contains('moisturizing') ||
          product.ingredients.contains('مرطب') ||
          product.name.contains('Balm') ||
          product.name.contains('Shine')) {
        score += 20;
      }
    }

    if (problems['needsLongLasting'] == true) {
      if (product.features.contains('long_lasting') ||
          product.features.contains('smudge_proof') ||
          product.name.contains('Infallible') ||
          product.finish == AppConstants.matteFinish) {
        score += 20;
      }
    }

    if (problems['needsEnvironmentalProtection'] == true) {
      if (product.features.contains('transfer_resistant') ||
          product.features.contains('water_resistant')) {
        score += 15;
      }
    }

    // مكافأة إضافية للمنتجات المخصصة للبشرة الحساسة
    if (survey.finalSkinType == AppConstants.sensitiveSkin) {
      if (product.name.contains('Paradise') ||
          product.features.contains('gentle') ||
          product.ingredients.contains('طبيعي')) {
        score += 10;
      }
    }

    return score.clamp(0.0, 100.0);
  }

  // حساب نقاط التفضيلات
  static double _calculatePreferencesScore(Product product, Survey survey) {
    double score = 50.0; // نقطة أساسية

    final preferences = survey.preferencesAnalysis;

    // نوع المنتج المطلوب
    final productType = preferences['productType'] as String?;
    if (productType != null) {
      score += _scoreProductType(product, productType);
    }

    // تفضيل الملمس
    final texturePreference = preferences['texturePreference'] as String?;
    if (texturePreference != null) {
      score += _scoreTexturePreference(product, texturePreference);
    }

    // المناسبة
    final occasionPreference = preferences['occasionPreference'] as String?;
    if (occasionPreference != null) {
      score += _scoreOccasionPreference(product, occasionPreference);
    }

    return score.clamp(0.0, 100.0);
  }

  static double _scoreProductType(Product product, String productType) {
    switch (productType) {
      case 'daily_lipstick':
        if (product.categoryName.contains('شفاه') &&
            (product.finish == AppConstants.naturalFinish ||
                product.name.contains('Balm'))) {
          return 25.0;
        }
        break;
      case 'evening_lipstick':
        if (product.categoryName.contains('شفاه') &&
            (product.finish == AppConstants.matteFinish ||
                product.name.contains('Infallible'))) {
          return 25.0;
        }
        break;
      case 'volume_mascara':
        if (product.categoryName.contains('مسكرة') &&
            product.name.contains('Paradise')) {
          return 25.0;
        }
        break;
      case 'dramatic_mascara':
        if (product.categoryName.contains('مسكرة') &&
            product.name.contains('Carbon Black')) {
          return 25.0;
        }
        break;
      case 'lip_balm':
        if (product.name.contains('Balm') ||
            product.name.contains('Paradise')) {
          return 25.0;
        }
        break;
      case 'daily_foundation':
        if (product.categoryName.contains('أساس') &&
            (product.finish == AppConstants.naturalFinish ||
                product.name.contains('True Match'))) {
          return 25.0;
        }
        break;
      case 'matte_foundation':
        if (product.categoryName.contains('أساس') &&
            (product.finish == AppConstants.matteFinish ||
                product.name.contains('Matte') ||
                product.name.contains('Studio Fix'))) {
          return 25.0;
        }
        break;
      case 'full_coverage_foundation':
        if (product.categoryName.contains('أساس') &&
            (product.features.contains('full_coverage') ||
                product.name.contains('Studio Fix'))) {
          return 25.0;
        }
        break;

    // === إضافة دعم لأحمر الخدود ===
      case 'natural_blush':
        if (product.categoryName.contains('خدود') &&
            (product.finish.contains('natural') ||
                product.name.contains('Orgasm'))) {
          return 25.0;
        }
        break;
      case 'glowing_blush':
        if (product.categoryName.contains('خدود') &&
            (product.finish.contains('glow') ||
                product.name.contains('Luminoso') ||
                product.features.contains('luminous'))) {
          return 25.0;
        }
        break;
      case 'long_lasting_blush':
        if (product.categoryName.contains('خدود') &&
            (product.features.contains('12_hour_wear') ||
                product.name.contains('Clay'))) {
          return 25.0;
        }
        break;

    // === إضافة دعم للبرونزر ===
      case 'contouring_bronzer':
        if (product.categoryName.contains('برونزر') &&
            (product.features.contains('contouring') ||
                product.name.contains('Hoola'))) {
          return 25.0;
        }
        break;
      case 'hydrating_bronzer':
        if (product.categoryName.contains('برونزر') &&
            (product.features.contains('hydrating') ||
                product.name.contains('Butter'))) {
          return 25.0;
        }
        break;
      case 'natural_bronzer':
        if (product.categoryName.contains('برونزر') &&
            (product.finish == AppConstants.naturalFinish ||
                product.name.contains('Chocolate'))) {
          return 25.0;
        }
        break;
    }
    return 0.0;
  }

  static double _scoreTexturePreference(Product product, String texturePreference) {
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
        if (product.finish == AppConstants.glossyFinish ||
            product.name.contains('Shine')) {
          return 20.0;
        }
        break;
      case 'matte_coverage':
        if (product.finish == AppConstants.matteFinish ||
            product.features.contains('oil_control') ||
            product.name.contains('Matte')) {
          return 20.0;
        }
        break;
      case 'natural_coverage':
        if (product.finish == AppConstants.naturalFinish ||
            product.features.contains('buildable_coverage') ||
            product.name.contains('True Match')) {
          return 20.0;
        }
        break;
      case 'full_coverage':
        if (product.features.contains('full_coverage') ||
            product.name.contains('Studio Fix')) {
          return 20.0;
        }
        break;
      case 'glowing_finish':
        if (product.finish.contains('glow') ||
            product.features.contains('luminous') ||
            product.name.contains('Luminoso')) {
          return 20.0;
        }
        break;
    }
    return 10.0; // نقاط متوسطة للباقي
  }

  static double _scoreOccasionPreference(Product product, String occasionPreference) {
    switch (occasionPreference) {
      case 'professional':
        if (product.occasion.contains('professional') ||
            product.finish == AppConstants.matteFinish) {
          return 15.0;
        }
        break;
      case 'social':
      case 'special_events':
        if (product.occasion.contains('evening') ||
            product.name.contains('Carbon Black') ||
            product.finish == AppConstants.glossyFinish) {
          return 15.0;
        }
        break;
      case 'daily':
        if (product.occasion.contains('daily') ||
            product.name.contains('Paradise')) {
          return 15.0;
        }
        break;
      case 'photography':
        if (product.occasion.contains('photography') ||
            product.features.contains('photo_ready') ||
            product.name.contains('Studio Fix')) {
          return 15.0;
        }
        break;
      case 'contouring':
        if (product.features.contains('contouring') ||
            product.name.contains('Hoola') ||
            product.categoryName.contains('برونزر')) {
          return 15.0;
        }
        break;
      case 'natural_enhancement':
        if (product.finish.contains('natural') ||
            product.name.contains('True Match') ||
            product.name.contains('Orgasm')) {
          return 15.0;
        }
        break;
      case 'summer_makeup':
        if (product.features.contains('tropical') ||
            product.name.contains('Butter') ||
            product.name.contains('Luminoso')) {
          return 15.0;
        }
        break;
    }
    return 5.0; // نقاط أساسية
  }

  // توليد أسباب التوصية
  static List<String> _generateRecommendationReasons(Product product, Survey survey) {
    List<String> reasons = [];

    // أسباب نوع البشرة
    final skinTypeScore = product.getSuitabilityScore(survey.finalSkinType);
    if (skinTypeScore > 80) {
      reasons.add('مثالي لبشرتك ${_getSkinTypeArabicName(survey.finalSkinType)}');
    }

    // أسباب المشاكل
    final problems = survey.problemsAnalysis;
    if (problems['needsMoisturizing'] == true &&
        product.features.contains('moisturizing')) {
      reasons.add('يوفر ترطيب ممتاز للشفاه');
    }

    if (problems['needsLongLasting'] == true &&
        product.features.contains('long_lasting')) {
      reasons.add('ثبات طويل يدوم لساعات');
    }

    // أسباب التفضيلات
    final preferences = survey.preferencesAnalysis;
    if (preferences['texturePreference'] == 'moisturizing' &&
        product.name.contains('Balm')) {
      reasons.add('ملمس مرطب وناعم كما تفضلين');
    }

    if (preferences['occasionPreference'] == 'professional' &&
        product.finish == AppConstants.matteFinish) {
      reasons.add('مناسب للإطلالة المهنية');
    }

    return reasons.take(3).toList(); // أقصى 3 أسباب
  }

  // حساب مستوى الثقة في التوصية
  static double _calculateRecommendationConfidence(Product product, Survey survey) {
    double confidence = survey.confidenceScore;

    // زيادة الثقة إذا كان المنتج يحل مشاكل محددة
    final problems = survey.problemsAnalysis;
    int problemsSolved = 0;
    int totalProblems = 0;

    if (problems['needsMoisturizing'] == true) {
      totalProblems++;
      if (product.features.contains('moisturizing')) problemsSolved++;
    }

    if (problems['needsLongLasting'] == true) {
      totalProblems++;
      if (product.features.contains('long_lasting')) problemsSolved++;
    }

    if (totalProblems > 0) {
      confidence *= (0.7 + (problemsSolved / totalProblems) * 0.3);
    }

    return confidence.clamp(0.5, 1.0);
  }

  static String _getSkinTypeArabicName(String skinType) {
    switch (skinType) {
      case AppConstants.oilySkin: return 'الدهنية';
      case AppConstants.drySkin: return 'الجافة';
      case AppConstants.combinationSkin: return 'المختلطة';
      case AppConstants.sensitiveSkin: return 'الحساسة';
      case AppConstants.normalSkin: return 'العادية';
      default: return 'الطبيعية';
    }
  }
}

// نموذج نتيجة التوصية
class ProductRecommendation {
  final Product product;
  final double score;
  final List<String> reasons;
  final double confidence;

  ProductRecommendation({
    required this.product,
    required this.score,
    required this.reasons,
    required this.confidence,
  });

  String get scorePercentage => '${score.toInt()}%';
  String get confidencePercentage => '${(confidence * 100).toInt()}%';
  bool get isHighRecommendation => score > 80;
  bool get isMediumRecommendation => score > 60 && score <= 80;
  bool get isLowRecommendation => score <= 60;
}
