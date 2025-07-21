// lib/data/models/survey_model.dart (Fixed)
import '../../../core/utils/calculation_utils.dart';

class SurveyQuestion {
  final String objectId;
  final int questionNumber;
  final String section;
  final String questionText;
  final String arabicQuestionText;
  final String questionType;
  final List<QuestionOption> options;
  final Map<String, dynamic> weights;
  final bool isActive;
  final int displayOrder;

  SurveyQuestion({
    required this.objectId,
    required this.questionNumber,
    required this.section,
    required this.questionText,
    required this.arabicQuestionText,
    required this.questionType,
    required this.options,
    required this.weights,
    required this.isActive,
    required this.displayOrder,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      objectId: json['objectId'] ?? '',
      questionNumber: CalculationUtils.safeIntFromDynamic(json['questionNumber']),
      section: json['section'] ?? '',
      questionText: json['questionText'] ?? '',
      arabicQuestionText: json['arabicQuestionText'] ?? '',
      questionType: json['questionType'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((option) => QuestionOption.fromJson(option))
          .toList(),
      weights: Map<String, dynamic>.from(json['weights'] ?? {}),
      isActive: json['isActive'] ?? true,
      displayOrder: CalculationUtils.safeIntFromDynamic(json['displayOrder']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'section': section,
      'questionText': questionText,
      'arabicQuestionText': arabicQuestionText,
      'questionType': questionType,
      'options': options.map((option) => option.toJson()).toList(),
      'weights': weights,
      'isActive': isActive,
      'displayOrder': displayOrder,
    };
  }

  // Helper methods
  bool get isSkinAnalysis => section == 'skin_analysis';
  bool get isProblemsAnalysis => section == 'problems';
  bool get isPreferences => section == 'preferences';
}

class QuestionOption {
  final String key;
  final String text;
  final String arabicText;
  final Map<String, int> weights;

  QuestionOption({
    required this.key,
    required this.text,
    required this.arabicText,
    required this.weights,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      key: json['key'] ?? '',
      text: json['text'] ?? '',
      arabicText: json['arabicText'] ?? '',
      // استخدام دالة آمنة لتحويل الأوزان
      weights: CalculationUtils.safeIntMapFromDynamic(json['weights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'text': text,
      'arabicText': arabicText,
      'weights': weights,
    };
  }
}

class Survey {
  final String objectId;
  final String userId;
  final Map<String, String> answers;
  final Map<String, double> skinAnalysis;
  final Map<String, dynamic> problemsAnalysis;
  final Map<String, dynamic> preferencesAnalysis;
  final String finalSkinType;
  final double confidenceScore;
  final List<String> recommendations;
  final Map<String, double> recommendationScores;
  final DateTime completedAt;
  final bool isActive;

  Survey({
    required this.objectId,
    required this.userId,
    required this.answers,
    required this.skinAnalysis,
    required this.problemsAnalysis,
    required this.preferencesAnalysis,
    required this.finalSkinType,
    required this.confidenceScore,
    required this.recommendations,
    required this.recommendationScores,
    required this.completedAt,
    required this.isActive,
  });

  // إضافة copyWith method
  Survey copyWith({
    String? objectId,
    String? userId,
    Map<String, String>? answers,
    Map<String, double>? skinAnalysis,
    Map<String, dynamic>? problemsAnalysis,
    Map<String, dynamic>? preferencesAnalysis,
    String? finalSkinType,
    double? confidenceScore,
    List<String>? recommendations,
    Map<String, double>? recommendationScores,
    DateTime? completedAt,
    bool? isActive,
  }) {
    return Survey(
      objectId: objectId ?? this.objectId,
      userId: userId ?? this.userId,
      answers: answers ?? this.answers,
      skinAnalysis: skinAnalysis ?? this.skinAnalysis,
      problemsAnalysis: problemsAnalysis ?? this.problemsAnalysis,
      preferencesAnalysis: preferencesAnalysis ?? this.preferencesAnalysis,
      finalSkinType: finalSkinType ?? this.finalSkinType,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      recommendations: recommendations ?? this.recommendations,
      recommendationScores: recommendationScores ?? this.recommendationScores,
      completedAt: completedAt ?? this.completedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      objectId: json['objectId'] ?? '',
      userId: json['user']?['objectId'] ?? '',
      answers: Map<String, String>.from(json['answers'] ?? {}),
      // استخدام دالة آمنة لتحويل البيانات
      skinAnalysis: CalculationUtils.safeDoubleMapFromDynamic(json['skinAnalysis']),
      problemsAnalysis: Map<String, dynamic>.from(json['problemsAnalysis'] ?? {}),
      preferencesAnalysis: Map<String, dynamic>.from(json['preferencesAnalysis'] ?? {}),
      finalSkinType: json['finalSkinType'] ?? '',
      confidenceScore: CalculationUtils.safeDoubleFromDynamic(json['confidenceScore']),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      recommendationScores: CalculationUtils.safeDoubleMapFromDynamic(json['recommendationScores']),
      completedAt: DateTime.tryParse(json['completedAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'__type': 'Pointer', 'className': '_User', 'objectId': userId},
      'answers': answers,
      'skinAnalysis': skinAnalysis,
      'problemsAnalysis': problemsAnalysis,
      'preferencesAnalysis': preferencesAnalysis,
      'finalSkinType': finalSkinType,
      'confidenceScore': confidenceScore,
      'recommendations': recommendations,
      'recommendationScores': recommendationScores,
      'completedAt': {'__type': 'Date', 'iso': completedAt.toIso8601String()},
      'isActive': isActive,
    };
  }

  // Helper methods
  String get confidencePercentage => '${(confidenceScore * 100).toInt()}%';
  bool get isHighConfidence => confidenceScore >= 0.8;
  bool get isMediumConfidence => confidenceScore >= 0.6 && confidenceScore < 0.8;
  bool get isLowConfidence => confidenceScore < 0.6;
}