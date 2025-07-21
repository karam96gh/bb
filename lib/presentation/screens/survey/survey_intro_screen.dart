
// lib/presentation/screens/survey/survey_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/survey_provider.dart';
import 'survey_question_screen.dart';

class SurveyIntroScreen extends StatelessWidget {
  const SurveyIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.smartSurvey),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, surveyProvider, child) {
          if (surveyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (surveyProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    surveyProvider.error!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => surveyProvider.loadQuestions(),
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),

                // Survey Overview
                _buildSurveyOverview(context),

                const SizedBox(height: 40),

                // Survey Steps
                _buildSurveySteps(context),

                const Spacer(),

                // Start Button
                _buildStartButton(context, surveyProvider),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSurveyOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.psychology,
              size: 48,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'الاستطلاع الذكي لتحليل البشرة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            AppStrings.surveyIntro,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildSurveySteps(BuildContext context) {
    final steps = [
      {
        'icon': Icons.face,
        'title': 'تحليل نوع البشرة',
        'description': '6 أسئلة لتحديد نوع بشرتك',
        'color': AppColors.oilySkinColor,
      },
      {
        'icon': Icons.help_outline,
        'title': 'تحديد المشاكل',
        'description': '4 أسئلة حول احتياجاتك',
        'color': AppColors.warning,
      },
      {
        'icon': Icons.favorite,
        'title': 'التفضيلات الشخصية',
        'description': '4 أسئلة عن تفضيلاتك',
        'color': AppColors.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مراحل الاستطلاع:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildStepItem(
              context,
              step['icon'] as IconData,
              step['title'] as String,
              step['description'] as String,
              step['color'] as Color,
              index + 1,
            ),
          )
              .animate(delay: Duration(milliseconds: 200 + (index * 100)))
              .slideX(
            begin: 0.3,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          )
              .fadeIn(duration: const Duration(milliseconds: 500));
        }).toList(),
      ],
    );
  }

  Widget _buildStepItem(BuildContext context, IconData icon, String title, String description, Color color, int stepNumber) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Step Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, SurveyProvider surveyProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _startSurvey(context, surveyProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 28),
            const SizedBox(width: 12),
            Text(
              'ابدأ الاستطلاع الآن',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: const Duration(milliseconds: 800))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 600));
  }

  void _startSurvey(BuildContext context, SurveyProvider surveyProvider) async {
    // Load questions if not already loaded
    if (surveyProvider.questions.isEmpty) {
      await surveyProvider.loadQuestions();
    }

    if (surveyProvider.questions.isNotEmpty) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const SurveyQuestionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }
}