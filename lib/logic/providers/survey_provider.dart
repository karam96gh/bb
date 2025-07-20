import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/survey_model.dart';
import '../../data/services/survey_service.dart';
import '../../logic/algorithms/skin_analysis_algorithm.dart';
import '../../core/constants/app_constants.dart';

class SurveyProvider extends ChangeNotifier {
  // Survey State
  List<SurveyQuestion> _questions = [];
  Map<String, String> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _error;

  // Results State
  Survey? _latestSurvey;
  Map<String, double> _skinAnalysis = {};
  Map<String, dynamic> _problemsAnalysis = {};
  Map<String, dynamic> _preferencesAnalysis = {};
  String _finalSkinType = AppConstants.normalSkin;
  double _confidenceScore = 0.0;

  // Getters
  List<SurveyQuestion> get questions => _questions;
  Map<String, String> get answers => _answers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Survey? get latestSurvey => _latestSurvey;
  Map<String, double> get skinAnalysis => _skinAnalysis;
  Map<String, dynamic> get problemsAnalysis => _problemsAnalysis;
  Map<String, dynamic> get preferencesAnalysis => _preferencesAnalysis;
  String get finalSkinType => _finalSkinType;
  double get confidenceScore => _confidenceScore;

  // Progress and navigation
  bool get canGoNext => _currentQuestionIndex < _questions.length - 1;
  bool get canGoPrevious => _currentQuestionIndex > 0;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  double get progress => _questions.isEmpty ? 0.0 : (_currentQuestionIndex + 1) / _questions.length;
  int get totalQuestions => _questions.length;
  int get currentQuestionNumber => _currentQuestionIndex + 1;

  // Helper getters
  String get currentAnswer => _answers['q$currentQuestionNumber'] ?? '';
  SurveyQuestion? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;

  // Load survey questions
  Future<void> loadQuestions() async {
    _setLoading(true);
    _error = null;

    try {
      _questions = await SurveyService.getAllQuestions();
      if (_questions.isEmpty) {
        _error = 'لم يتم العثور على أسئلة الاستطلاع';
      }
    } catch (e) {
      _error = 'خطأ في تحميل الأسئلة: $e';
      print('❌ Error loading questions: $e');
    }

    _setLoading(false);
  }

  // Answer current question
  void answerCurrentQuestion(String answer) {
    if (currentQuestion != null) {
      _answers['q$currentQuestionNumber'] = answer;
      notifyListeners();
    }
  }

  // Navigation methods
  void goToNextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void goToPreviousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  // Process survey and calculate results
  Future<bool> processSurveyResults(String userId) async {
    if (_questions.isEmpty || _answers.length != _questions.length) {
      _error = 'الرجاء الإجابة على جميع الأسئلة';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      // Analyze skin type
      _skinAnalysis = SkinAnalysisAlgorithm.analyzeSkinType(_questions, _answers);
      _finalSkinType = SkinAnalysisAlgorithm.determinePrimarySkinType(_skinAnalysis);
      _confidenceScore = SkinAnalysisAlgorithm.calculateConfidenceScore(_skinAnalysis);

      // Analyze problems
      _problemsAnalysis = SkinAnalysisAlgorithm.analyzeProblems(_questions, _answers);

      // Analyze preferences
      _preferencesAnalysis = SkinAnalysisAlgorithm.analyzePreferences(_questions, _answers);

      // Create survey object
      final survey = Survey(
        objectId: '',
        userId: userId,
        answers: _answers,
        skinAnalysis: _skinAnalysis,
        problemsAnalysis: _problemsAnalysis,
        preferencesAnalysis: _preferencesAnalysis,
        finalSkinType: _finalSkinType,
        confidenceScore: _confidenceScore,
        recommendations: [], // Will be filled by recommendation provider
        recommendationScores: {},
        completedAt: DateTime.now(),
        isActive: true,
      );

      // Save to database
      final surveyId = await SurveyService.saveSurveyResults(survey);
      if (surveyId != null) {
        _latestSurvey = survey.copyWith(objectId: surveyId);

        // Save to local preferences
        await _saveToLocalPreferences();

        _setLoading(false);
        return true;
      } else {
        _error = 'فشل في حفظ نتائج الاستطلاع';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'خطأ في معالجة النتائج: $e';
      print('❌ Error processing survey: $e');
      _setLoading(false);
      return false;
    }
  }

  // Save results to local preferences
  Future<void> _saveToLocalPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userSkinTypeKey, _finalSkinType);
      await prefs.setString(AppConstants.lastSurveyDateKey, DateTime.now().toIso8601String());

      // Save basic preferences
      final prefsMap = {
        'skinType': _finalSkinType,
        'confidenceScore': _confidenceScore,
        'lastSurveyDate': DateTime.now().toIso8601String(),
      };
      await prefs.setString(AppConstants.userPreferencesKey, prefsMap.toString());
    } catch (e) {
      print('❌ Error saving to local preferences: $e');
    }
  }

  // Load user's survey history
  Future<void> loadUserSurveyHistory(String userId) async {
    _setLoading(true);

    try {
      final surveys = await SurveyService.getUserSurveys(userId);
      if (surveys.isNotEmpty) {
        _latestSurvey = surveys.first;
        _skinAnalysis = _latestSurvey!.skinAnalysis;
        _problemsAnalysis = _latestSurvey!.problemsAnalysis;
        _preferencesAnalysis = _latestSurvey!.preferencesAnalysis;
        _finalSkinType = _latestSurvey!.finalSkinType;
        _confidenceScore = _latestSurvey!.confidenceScore;
      }
    } catch (e) {
      _error = 'خطأ في تحميل سجل الاستطلاعات: $e';
      print('❌ Error loading survey history: $e');
    }

    _setLoading(false);
  }

  // Reset survey
  void resetSurvey() {
    _answers.clear();
    _currentQuestionIndex = 0;
    _skinAnalysis.clear();
    _problemsAnalysis.clear();
    _preferencesAnalysis.clear();
    _finalSkinType = AppConstants.normalSkin;
    _confidenceScore = 0.0;
    _error = null;
    notifyListeners();
  }

  // Check if user has completed survey before
  Future<bool> hasCompletedSurvey(String userId) async {
    try {
      final latestSurvey = await SurveyService.getLatestUserSurvey(userId);
      return latestSurvey != null;
    } catch (e) {
      print('❌ Error checking survey completion: $e');
      return false;
    }
  }

  // Get skin type display name
  String getSkinTypeDisplayName() {
    switch (_finalSkinType) {
      case AppConstants.oilySkin: return 'بشرة دهنية';
      case AppConstants.drySkin: return 'بشرة جافة';
      case AppConstants.combinationSkin: return 'بشرة مختلطة';
      case AppConstants.sensitiveSkin: return 'بشرة حساسة';
      case AppConstants.normalSkin: return 'بشرة عادية';
      default: return 'غير محدد';
    }
  }

  // Get confidence level text
  String getConfidenceLevelText() {
    if (_confidenceScore >= 0.8) return 'عالية';
    if (_confidenceScore >= 0.6) return 'متوسطة';
    return 'منخفضة';
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

  // Copy survey for updates
  Survey copyWith({String? objectId}) {
    return Survey(
      objectId: objectId ?? _latestSurvey?.objectId ?? '',
      userId: _latestSurvey?.userId ?? '',
      answers: _answers,
      skinAnalysis: _skinAnalysis,
      problemsAnalysis: _problemsAnalysis,
      preferencesAnalysis: _preferencesAnalysis,
      finalSkinType: _finalSkinType,
      confidenceScore: _confidenceScore,
      recommendations: _latestSurvey?.recommendations ?? [],
      recommendationScores: _latestSurvey?.recommendationScores ?? {},
      completedAt: _latestSurvey?.completedAt ?? DateTime.now(),
      isActive: true,
    );
  }
}