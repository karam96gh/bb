// lib/logic/algorithms/skin_analysis_algorithm.dart
import '../../data/models/survey_model.dart';
import '../../core/constants/app_constants.dart';

class SkinAnalysisAlgorithm {
  // تحليل نوع البشرة بناءً على إجابات الاستطلاع
  static Map<String, double> analyzeSkinType(
      List<SurveyQuestion> questions,
      Map<String, String> answers,
      ) {
    Map<String, double> skinTypeScores = {
      AppConstants.oilySkin: 0.0,
      AppConstants.drySkin: 0.0,
      AppConstants.combinationSkin: 0.0,
      AppConstants.sensitiveSkin: 0.0,
      AppConstants.normalSkin: 0.0,
    };

    // تحليل الأسئلة الخاصة بنوع البشرة (1-6)
    final skinAnalysisQuestions = questions
        .where((q) => q.section == AppConstants.skinAnalysisSection)
        .toList();

    for (var question in skinAnalysisQuestions) {
      final userAnswer = answers['q${question.questionNumber}'];
      if (userAnswer == null) continue;

      // البحث عن الخيار المطابق
      final selectedOption = question.options
          .firstWhere((option) => option.key == userAnswer, orElse: () => question.options.first);

      // إضافة النقاط لكل نوع بشرة
      selectedOption.weights.forEach((skinType, points) {
        if (skinTypeScores.containsKey(skinType)) {
          skinTypeScores[skinType] = skinTypeScores[skinType]! + points.toDouble();
        }
      });
    }

    // تطبيق أوزان إضافية بناءً على نوع السؤال
    _applyQuestionWeights(skinTypeScores, answers);

    // تطبيع النقاط (0-100)
    _normalizeScores(skinTypeScores);

    return skinTypeScores;
  }

  // تطبيق أوزان إضافية
  static void _applyQuestionWeights(Map<String, double> scores, Map<String, String> answers) {
    // السؤال 1 (اختبار المنديل) له وزن أعلى
    final q1Answer = answers['q1'];
    if (q1Answer != null) {
      switch (q1Answer) {
        case 'أ': // زيوت كثيرة
          scores[AppConstants.oilySkin] = scores[AppConstants.oilySkin]! * 1.3;
          break;
        case 'ب': // زيوت في منطقة T
          scores[AppConstants.combinationSkin] = scores[AppConstants.combinationSkin]! * 1.3;
          break;
        case 'ج': // لا توجد زيوت
          scores[AppConstants.drySkin] = scores[AppConstants.drySkin]! * 1.3;
          break;
      }
    }

    // السؤال 4 (التفاعل مع المنتجات) مهم للبشرة الحساسة
    final q4Answer = answers['q4'];
    if (q4Answer == 'ج') { // تهيج فوري
      scores[AppConstants.sensitiveSkin] = scores[AppConstants.sensitiveSkin]! * 1.4;
    }

    // السؤال 5 (تأثير الطقس)
    final q5Answer = answers['q5'];
    if (q5Answer != null) {
      switch (q5Answer) {
        case 'أ': // دهنية في الحر
          scores[AppConstants.oilySkin] = scores[AppConstants.oilySkin]! * 1.2;
          break;
        case 'ب': // جافة في البرد
          scores[AppConstants.drySkin] = scores[AppConstants.drySkin]! * 1.2;
          break;
        case 'هـ': // متغيرة حسب الموسم
          scores[AppConstants.combinationSkin] = scores[AppConstants.combinationSkin]! * 1.2;
          break;
      }
    }
  }

  // تطبيع النقاط لتكون من 0 إلى 100
  static void _normalizeScores(Map<String, double> scores) {
    final maxScore = scores.values.reduce((a, b) => a > b ? a : b);
    if (maxScore > 0) {
      scores.updateAll((key, value) => (value / maxScore) * 100);
    }
  }

  // تحديد نوع البشرة الأساسي
  static String determinePrimarySkinType(Map<String, double> scores) {
    String primaryType = AppConstants.normalSkin;
    double highestScore = 0.0;

    scores.forEach((skinType, score) {
      if (score > highestScore) {
        highestScore = score;
        primaryType = skinType;
      }
    });

    return primaryType;
  }

  // حساب مستوى الثقة في التحليل
  static double calculateConfidenceScore(Map<String, double> scores) {
    final sortedScores = scores.values.toList()..sort((a, b) => b.compareTo(a));

    if (sortedScores.length < 2) return 1.0;

    final highest = sortedScores[0];
    final secondHighest = sortedScores[1];

    // كلما زادت الفجوة بين الأعلى والثاني، زادت الثقة
    final gap = highest - secondHighest;
    final confidence = (gap / 100).clamp(0.5, 1.0);

    return confidence;
  }

  // تحليل المشاكل المحددة (الأسئلة 7-10)
  static Map<String, dynamic> analyzeProblems(
      List<SurveyQuestion> questions,
      Map<String, String> answers,
      ) {
    Map<String, int> problemScores = {
      'drying': 0,
      'smudging': 0,
      'fading': 0,
      'environmental': 0,
      'lifestyle': 0,
    };

    final problemQuestions = questions
        .where((q) => q.section == AppConstants.problemsSection)
        .toList();

    for (var question in problemQuestions) {
      final userAnswer = answers['q${question.questionNumber}'];
      if (userAnswer == null) continue;

      switch (question.questionNumber) {
        case 7: // مشاكل أحمر الشفاه
          _analyzeLipstickProblems(userAnswer, problemScores);
          break;
        case 8: // احتياجات المسكرة
          _analyzeMascaraNeeds(userAnswer, problemScores);
          break;
        case 9: // التحديات البيئية
          _analyzeEnvironmentalChallenges(userAnswer, problemScores);
          break;
        case 10: // العوامل المؤثرة
          _analyzeLifestyleFactors(userAnswer, problemScores);
          break;
      }
    }

    return {
      'problemScores': problemScores,
      'primaryProblem': _determinePrimaryProblem(problemScores),
      'needsMoisturizing': problemScores['drying']! > 2,
      'needsLongLasting': problemScores['smudging']! > 2 || problemScores['fading']! > 2,
      'needsEnvironmentalProtection': problemScores['environmental']! > 2,
    };
  }

  static void _analyzeLipstickProblems(String answer, Map<String, int> scores) {
    switch (answer) {
      case 'أ': // يجف الشفاه
        scores['drying'] = scores['drying']! + 3;
        break;
      case 'ب': // يتلطخ
        scores['smudging'] = scores['smudging']! + 3;
        break;
      case 'ج': // يبهت
        scores['fading'] = scores['fading']! + 3;
        break;
    }
  }

  static void _analyzeMascaraNeeds(String answer, Map<String, int> scores) {
    switch (answer) {
      case 'أ': // تكثيف
      case 'ب': // إطالة
        scores['fading'] = scores['fading']! + 1;
        break;
      case 'ج': // حجم درامي
        scores['smudging'] = scores['smudging']! + 1;
        break;
    }
  }

  static void _analyzeEnvironmentalChallenges(String answer, Map<String, int> scores) {
    switch (answer) {
      case 'أ': // مكتب مكيف
        scores['drying'] = scores['drying']! + 2;
        break;
      case 'ب': // خارج المنزل
        scores['environmental'] = scores['environmental']! + 3;
        break;
      case 'ج': // أماكن حارة
        scores['smudging'] = scores['smudging']! + 2;
        scores['environmental'] = scores['environmental']! + 2;
        break;
      case 'د': // بيئة رطبة
        scores['smudging'] = scores['smudging']! + 2;
        break;
    }
  }

  static void _analyzeLifestyleFactors(String answer, Map<String, int> scores) {
    switch (answer) {
      case 'أ': // قلة النوم
        scores['lifestyle'] = scores['lifestyle']! + 2;
        break;
      case 'ب': // التوتر
        scores['lifestyle'] = scores['lifestyle']! + 3;
        break;
    }
  }

  static String _determinePrimaryProblem(Map<String, int> scores) {
    String primaryProblem = 'none';
    int highestScore = 0;

    scores.forEach((problem, score) {
      if (score > highestScore) {
        highestScore = score;
        primaryProblem = problem;
      }
    });

    return primaryProblem;
  }

  // تحليل التفضيلات (الأسئلة 11-14)
  static Map<String, dynamic> analyzePreferences(
      List<SurveyQuestion> questions,
      Map<String, String> answers,
      ) {
    final preferencesQuestions = questions
        .where((q) => q.section == AppConstants.preferencesSection)
        .toList();

    Map<String, dynamic> preferences = {
      'productType': '',
      'colorPreference': '',
      'texturePreference': '',
      'occasionPreference': '',
      'priorityFeature': '',
    };

    for (var question in preferencesQuestions) {
      final userAnswer = answers['q${question.questionNumber}'];
      if (userAnswer == null) continue;

      switch (question.questionNumber) {
        case 11: // نوع المنتج المطلوب
          preferences['productType'] = _determineProductType(userAnswer);
          break;
        case 12: // تفضيل الألوان
          preferences['colorPreference'] = _determineColorPreference(userAnswer);
          break;
        case 13: // تفضيل الملمس
          preferences['texturePreference'] = _determineTexturePreference(userAnswer);
          break;
        case 14: // المناسبة
          preferences['occasionPreference'] = _determineOccasionPreference(userAnswer);
          break;
      }
    }

    return preferences;
  }

  static String _determineProductType(String answer) {
    switch (answer) {
      case 'أ': return 'daily_lipstick';
      case 'ب': return 'evening_lipstick';
      case 'ج': return 'volume_mascara';
      case 'د': return 'dramatic_mascara';
      case 'هـ': return 'lip_balm';
      case 'و': return 'all_products';
      default: return 'lipstick';
    }
  }

  static String _determineColorPreference(String answer) {
    switch (answer) {
      case 'أ': return 'natural';
      case 'ب': return 'bold';
      case 'ج': return 'varied';
      case 'د': return 'classic';
      default: return 'natural';
    }
  }

  static String _determineTexturePreference(String answer) {
    switch (answer) {
      case 'أ': return 'long_lasting';
      case 'ب': return 'moisturizing';
      case 'ج': return 'glossy';
      case 'د': return 'balanced';
      case 'هـ': return 'easy_application';
      default: return 'balanced';
    }
  }

  static String _determineOccasionPreference(String answer) {
    switch (answer) {
      case 'أ': return 'professional';
      case 'ب': return 'social';
      case 'ج': return 'special_events';
      case 'د': return 'daily';
      case 'هـ': return 'night_care';
      default: return 'daily';
    }
  }
}
