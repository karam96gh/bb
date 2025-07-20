// lib/presentation/screens/survey/survey_question_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/survey_provider.dart';
import '../../../data/models/survey_model.dart';
import 'survey_results_screen.dart';

class SurveyQuestionScreen extends StatefulWidget {
  const SurveyQuestionScreen({Key? key}) : super(key: key);

  @override
  State<SurveyQuestionScreen> createState() => _SurveyQuestionScreenState();
}

class _SurveyQuestionScreenState extends State<SurveyQuestionScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _questionController;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _questionController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<SurveyProvider>(
        builder: (context, surveyProvider, child) {
          if (surveyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (surveyProvider.error != null) {
            return _buildErrorState(context, surveyProvider);
          }

          final currentQuestion = surveyProvider.currentQuestion;
          if (currentQuestion == null) {
            return const Center(
              child: Text('لا توجد أسئلة متاحة'),
            );
          }

          // Update selected answer when question changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final currentAnswer = surveyProvider.currentAnswer;
            if (_selectedAnswer != currentAnswer) {
              setState(() {
                _selectedAnswer = currentAnswer;
              });
            }
          });

          return Column(
            children: [
              // Progress Bar
              _buildProgressBar(surveyProvider),

              // Question Content
              Expanded(
                child: _buildQuestionContent(context, currentQuestion, surveyProvider),
              ),

              // Navigation Buttons
              _buildNavigationButtons(context, surveyProvider),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Consumer<SurveyProvider>(
        builder: (context, surveyProvider, child) {
          return Text(
            '${AppStrings.question} ${surveyProvider.currentQuestionNumber} ${AppStrings.of} ${surveyProvider.totalQuestions}',
          );
        },
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildProgressBar(SurveyProvider surveyProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${(surveyProvider.progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: surveyProvider.progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: -0.5,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildQuestionContent(BuildContext context, SurveyQuestion question, SurveyProvider surveyProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Badge
          _buildSectionBadge(question.section),

          const SizedBox(height: 20),

          // Question Text
          _buildQuestionText(context, question),

          const SizedBox(height: 32),

          // Answer Options
          _buildAnswerOptions(context, question, surveyProvider),
        ],
      ),
    );
  }

  Widget _buildSectionBadge(String section) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (section) {
      case 'skin_analysis':
        badgeColor = AppColors.oilySkinColor;
        badgeText = 'تحليل البشرة';
        badgeIcon = Icons.face;
        break;
      case 'problems':
        badgeColor = AppColors.warning;
        badgeText = 'تحديد المشاكل';
        badgeIcon = Icons.help_outline;
        break;
      case 'preferences':
        badgeColor = AppColors.primary;
        badgeText = 'التفضيلات';
        badgeIcon = Icons.favorite;
        break;
      default:
        badgeColor = AppColors.info;
        badgeText = 'سؤال عام';
        badgeIcon = Icons.quiz;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 16,
            color: badgeColor,
          ),
          const SizedBox(width: 8),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    )
        .animate()
        .scale(
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
    )
        .fadeIn();
  }

  Widget _buildQuestionText(BuildContext context, SurveyQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        question.arabicQuestionText,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    )
        .animate()
        .slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildAnswerOptions(BuildContext context, SurveyQuestion question, SurveyProvider surveyProvider) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedAnswer == option.key;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildOptionCard(context, option, isSelected, () {
            setState(() {
              _selectedAnswer = option.key;
            });
            surveyProvider.answerCurrentQuestion(option.key);
          }),
        )
            .animate(delay: Duration(milliseconds: 100 + (index * 50)))
            .slideX(
          begin: 0.4,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        )
            .fadeIn(duration: const Duration(milliseconds: 300));
      }).toList(),
    );
  }

  Widget _buildOptionCard(BuildContext context, QuestionOption option, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Option Key
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  option.key,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Option Text
            Expanded(
              child: Text(
                option.arabicText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, SurveyProvider surveyProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous Button
          if (surveyProvider.canGoPrevious)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _goToPrevious(surveyProvider),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppStrings.previous),
              ),
            ),

          if (surveyProvider.canGoPrevious) const SizedBox(width: 16),

          // Next/Finish Button
          Expanded(
            flex: surveyProvider.canGoPrevious ? 1 : 2,
            child: ElevatedButton(
              onPressed: _selectedAnswer != null
                  ? () => _goToNext(context, surveyProvider)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                surveyProvider.isLastQuestion ? AppStrings.finish : AppStrings.next,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  Widget _buildErrorState(BuildContext context, SurveyProvider surveyProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
      ),
    );
  }

  void _goToPrevious(SurveyProvider surveyProvider) {
    _questionController.reverse().then((_) {
      surveyProvider.goToPreviousQuestion();
      setState(() {
        _selectedAnswer = surveyProvider.currentAnswer;
      });
      _questionController.forward();
    });
  }

  void _goToNext(BuildContext context, SurveyProvider surveyProvider) async {
    if (surveyProvider.isLastQuestion) {
      // Finish survey
      _showLoadingDialog(context);

      // TODO: Get actual user ID from authentication
      const userId = 'temp_user_id';

      final success = await surveyProvider.processSurveyResults(userId);

      Navigator.of(context).pop(); // Remove loading dialog

      if (success) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const SurveyResultsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        _showErrorDialog(context, surveyProvider.error ?? 'حدث خطأ غير متوقع');
      }
    } else {
      // Go to next question
      _questionController.reverse().then((_) {
        surveyProvider.goToNextQuestion();
        setState(() {
          _selectedAnswer = surveyProvider.currentAnswer;
        });
        _questionController.forward();
      });
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'جاري تحليل إجاباتك...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
