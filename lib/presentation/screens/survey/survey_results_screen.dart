
// lib/presentation/screens/survey/survey_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/survey_provider.dart';
import '../../../logic/providers/recommendation_provider.dart';
import '../../navigation/bottom_navigation.dart';

class SurveyResultsScreen extends StatefulWidget {
  const SurveyResultsScreen({Key? key}) : super(key: key);

  @override
  State<SurveyResultsScreen> createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsScreen> {
  @override
  void initState() {
    super.initState();
    _generateRecommendations();
  }

  void _generateRecommendations() async {
    final surveyProvider = context.read<SurveyProvider>();
    final recommendationProvider = context.read<RecommendationProvider>();

    if (surveyProvider.latestSurvey != null) {
      await recommendationProvider.generateRecommendations(surveyProvider.latestSurvey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.yourResults),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<SurveyProvider, RecommendationProvider>(
        builder: (context, surveyProvider, recommendationProvider, child) {
          if (surveyProvider.latestSurvey == null) {
            return const Center(
              child: Text('لا توجد نتائج متاحة'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Congratulations Header
                _buildCongratulationsHeader(context),

                const SizedBox(height: 32),

                // Skin Type Result
                _buildSkinTypeResult(context, surveyProvider),

                const SizedBox(height: 24),

                // Confidence Score
                _buildConfidenceScore(context, surveyProvider),

                const SizedBox(height: 32),

                // Recommendations Section
                _buildRecommendationsSection(context, recommendationProvider),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(context),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCongratulationsHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.celebration,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تهانينا! 🎉',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تم تحليل بشرتك بنجاح وإعداد توصيات مخصصة لك',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .scale(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildSkinTypeResult(BuildContext context, SurveyProvider surveyProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.face,
                color: AppColors.getSkinTypeColor(surveyProvider.finalSkinType),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'نوع بشرتك',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.getSkinTypeColor(surveyProvider.finalSkinType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.getSkinTypeColor(surveyProvider.finalSkinType).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.getSkinTypeColor(surveyProvider.finalSkinType),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  surveyProvider.getSkinTypeDisplayName(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.getSkinTypeColor(surveyProvider.finalSkinType),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            _getSkinTypeDescription(surveyProvider.finalSkinType),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 200))
        .slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildConfidenceScore(BuildContext context, SurveyProvider surveyProvider) {
    final confidence = surveyProvider.confidenceScore;
    final confidencePercentage = (confidence * 100).toInt();

    Color confidenceColor;
    String confidenceText;
    if (confidence >= 0.8) {
      confidenceColor = AppColors.success;
      confidenceText = 'عالية';
    } else if (confidence >= 0.6) {
      confidenceColor = AppColors.warning;
      confidenceText = 'متوسطة';
    } else {
      confidenceColor = AppColors.error;
      confidenceText = 'منخفضة';
    }

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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: confidenceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.psychology,
              color: confidenceColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دقة التحليل',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$confidenceText ($confidencePercentage%)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: confidenceColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Circular Progress
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: confidence,
              backgroundColor: confidenceColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(confidenceColor),
              strokeWidth: 6,
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 400))
        .slideX(
      begin: -0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildRecommendationsSection(BuildContext context, RecommendationProvider recommendationProvider) {
    if (recommendationProvider.isLoading) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'جاري إعداد التوصيات المخصصة لك...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (recommendationProvider.recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            Text(
              'لم نتمكن من إعداد توصيات مناسبة حالياً',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المنتجات المقترحة لك',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ...recommendationProvider.recommendations.take(3).map((recommendation) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildRecommendationCard(context, recommendation),
          );
        }).toList(),

        if (recommendationProvider.recommendations.length > 3)
          TextButton(
            onPressed: () {
              // Navigate to full recommendations
            },
            child: Text('عرض جميع التوصيات (${recommendationProvider.recommendations.length})'),
          ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildRecommendationCard(BuildContext context, dynamic recommendation) {
    final product = recommendation.product;
    final score = recommendation.score;
    final reasons = recommendation.reasons as List<String>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: AppColors.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.arabicName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  reasons.isNotEmpty ? reasons.first : 'موصى به لك',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${score.toInt()}% توافق',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      product.displayPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // View All Recommendations Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _navigateToProducts(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'عرض جميع التوصيات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Retake Survey Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _retakeSurvey(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(AppStrings.retakeSurvey),
          ),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 800))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }

  String _getSkinTypeDescription(String skinType) {
    switch (skinType) {
      case 'oily':
        return 'بشرتك تميل للدهنية مع لمعان واضح ومسام ظاهرة. نوصي بمنتجات مطفية وطويلة الثبات.';
      case 'dry':
        return 'بشرتك جافة وتحتاج ترطيب إضافي. نوصي بمنتجات مرطبة وناعمة الملمس.';
      case 'combination':
        return 'بشرتك مختلطة - دهنية في منطقة T وعادية أو جافة في باقي الوجه. نوصي بمنتجات متوازنة.';
      case 'sensitive':
        return 'بشرتك حساسة وتحتاج منتجات لطيفة خالية من المواد المهيجة.';
      case 'normal':
        return 'بشرتك عادية ومتوازنة. يمكنك استخدام معظم أنواع المنتجات بأمان.';
      default:
        return 'تم تحليل نوع بشرتك بنجاح وإعداد توصيات مناسبة لك.';
    }
  }

  void _navigateToProducts(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const BottomNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _retakeSurvey(BuildContext context) {
    final surveyProvider = context.read<SurveyProvider>();
    surveyProvider.resetSurvey();

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/survey_intro',
          (route) => false,
    );
  }
}