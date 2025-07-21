// lib/data/services/survey_service.dart (Fixed)
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/survey_model.dart';
import 'back4app_service.dart';
import '../../core/constants/app_constants.dart';

class SurveyService {
  // Get all survey questions
  static Future<List<SurveyQuestion>> getAllQuestions() async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.surveyQuestionsTable);
      query.whereEqualTo('isActive', true);
      query.orderByAscending('displayOrder');

      final results = await Back4AppService.queryWithConditions(query);

      // Debug: Print the raw results to see the data structure
      print('📋 Raw survey questions data:');
      for (int i = 0; i < results.length && i < 2; i++) {
        print('Question ${i + 1}: ${results[i].toJson()}');
      }

      final questions = <SurveyQuestion>[];

      for (final result in results) {
        try {
          final question = SurveyQuestion.fromJson(result.toJson());
          questions.add(question);
        } catch (e) {
          print('❌ Error parsing question: ${result.get('questionNumber')} - $e');
          print('Raw data: ${result.toJson()}');
          // Skip this question and continue with others
          continue;
        }
      }

      print('✅ Successfully parsed ${questions.length} questions out of ${results.length} total');
      return questions;

    } catch (e) {
      print('❌ Error getting survey questions: $e');
      return [];
    }
  }

  // Get questions by section
  static Future<List<SurveyQuestion>> getQuestionsBySection(String section) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.surveyQuestionsTable);
      query.whereEqualTo('section', section);
      query.whereEqualTo('isActive', true);
      query.orderByAscending('displayOrder');

      final results = await Back4AppService.queryWithConditions(query);

      final questions = <SurveyQuestion>[];
      for (final result in results) {
        try {
          final question = SurveyQuestion.fromJson(result.toJson());
          questions.add(question);
        } catch (e) {
          print('❌ Error parsing question in section $section: $e');
          continue;
        }
      }

      return questions;
    } catch (e) {
      print('❌ Error getting questions by section: $e');
      return [];
    }
  }

  // Save survey results
  static Future<String?> saveSurveyResults(Survey survey) async {
    try {
      final data = survey.toJson();
      return await Back4AppService.create(AppConstants.surveysTable, data);
    } catch (e) {
      print('❌ Error saving survey results: $e');
      return null;
    }
  }

  // Get user's survey history
  static Future<List<Survey>> getUserSurveys(String userId) async {
    try {
      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.surveysTable);
      query.whereEqualTo('user', ParseObject(AppConstants.usersTable)..objectId = userId);
      query.whereEqualTo('isActive', true);
      query.orderByDescending('completedAt');

      final results = await Back4AppService.queryWithConditions(query);
      return results.map((result) => Survey.fromJson(result.toJson())).toList();
    } catch (e) {
      print('❌ Error getting user surveys: $e');
      return [];
    }
  }

  // Get latest survey for user
  static Future<Survey?> getLatestUserSurvey(String userId) async {
    try {
      final surveys = await getUserSurveys(userId);
      return surveys.isNotEmpty ? surveys.first : null;
    } catch (e) {
      print('❌ Error getting latest user survey: $e');
      return null;
    }
  }

  // Update survey
  static Future<bool> updateSurvey(String surveyId, Map<String, dynamic> updates) async {
    try {
      return await Back4AppService.update(AppConstants.surveysTable, surveyId, updates);
    } catch (e) {
      print('❌ Error updating survey: $e');
      return false;
    }
  }

  // Test function to validate question structure
  static Future<void> validateQuestionStructure() async {
    try {
      print('🔍 Validating question structure...');

      final query = Back4AppService.buildQuery<ParseObject>(AppConstants.surveyQuestionsTable);
      query.setLimit(1);

      final results = await Back4AppService.queryWithConditions(query);

      if (results.isNotEmpty) {
        final rawData = results.first.toJson();
        print('📋 Sample question structure:');
        print('Keys: ${rawData.keys.toList()}');

        if (rawData['options'] != null) {
          final options = rawData['options'] as List;
          if (options.isNotEmpty) {
            print('📋 Sample option structure:');
            print(options.first);

            final sampleOption = options.first as Map<String, dynamic>;
            if (sampleOption['weights'] != null) {
              print('📋 Sample weights structure:');
              print('Weights type: ${sampleOption['weights'].runtimeType}');
              print('Weights content: ${sampleOption['weights']}');
            }
          }
        }
      }
    } catch (e) {
      print('❌ Error validating question structure: $e');
    }
  }
}