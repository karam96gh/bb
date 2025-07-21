// lib/core/widgets/question_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../../data/models/survey_model.dart';

class QuestionCard extends StatelessWidget {
  final SurveyQuestion question;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;
  final int questionIndex;
  final int totalQuestions;

  const QuestionCard({
    Key? key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
    required this.questionIndex,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),

          // Question Content
          _buildQuestionContent(context),

          // Options
          _buildOptions(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _getSectionGradient(question.section),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getSectionIcon(question.section),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getSectionTitle(question.section),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'السؤال ${questionIndex + 1} من $totalQuestions',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: -0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildQuestionContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.arabicQuestionText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (question.questionText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 200))
        .slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == option.key;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: _buildOptionTile(context, option, isSelected),
          )
              .animate(delay: Duration(milliseconds: 300 + (index * 100)))
              .slideX(
            begin: 0.4,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          )
              .fadeIn();
        }).toList(),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, QuestionOption option, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onAnswerSelected(option.key),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? _getSectionColor(question.section).withOpacity(0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? _getSectionColor(question.section)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Option Key Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getSectionColor(question.section)
                      : AppColors.onSurfaceVariant.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    option.key,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Option Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.arabicText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? _getSectionColor(question.section)
                            : AppColors.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (option.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        option.text,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: _getSectionColor(question.section),
                  size: 24,
                )
              else
                Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.onSurfaceVariant.withOpacity(0.5),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSectionColor(String section) {
    switch (section) {
      case 'skin_analysis':
        return AppColors.oilySkinColor;
      case 'problems':
        return AppColors.warning;
      case 'preferences':
        return AppColors.primary;
      default:
        return AppColors.info;
    }
  }

  LinearGradient _getSectionGradient(String section) {
    final color = _getSectionColor(section);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(0.8)],
    );
  }

  IconData _getSectionIcon(String section) {
    switch (section) {
      case 'skin_analysis':
        return Icons.face;
      case 'problems':
        return Icons.help_outline;
      case 'preferences':
        return Icons.favorite;
      default:
        return Icons.quiz;
    }
  }

  String _getSectionTitle(String section) {
    switch (section) {
      case 'skin_analysis':
        return 'تحليل البشرة';
      case 'problems':
        return 'تحديد المشاكل';
      case 'preferences':
        return 'التفضيلات';
      default:
        return 'سؤال عام';
    }
  }
}

// Progress indicator for survey
class SurveyProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Color? color;

  const SurveyProgressIndicator({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0 ? currentQuestion / totalQuestions : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
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
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color ?? AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

// Survey navigation buttons
class SurveyNavigationButtons extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isLastQuestion;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onFinish;

  const SurveyNavigationButtons({
    Key? key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isLastQuestion,
    this.onPrevious,
    this.onNext,
    this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: SafeArea(
        child: Row(
          children: [
            // Previous Button
            if (canGoPrevious)
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('السابق'),
                ),
              ),

            if (canGoPrevious) const SizedBox(width: 16),

            // Next/Finish Button
            Expanded(
              flex: canGoPrevious ? 1 : 2,
              child: ElevatedButton(
                onPressed: isLastQuestion ? onFinish : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastQuestion ? 'إنهاء' : 'التالي',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}