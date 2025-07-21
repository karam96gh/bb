// lib/presentation/screens/profile/survey_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../logic/providers/survey_provider.dart';
import '../../../data/models/survey_model.dart';
import '../../../logic/providers/uth_provider.dart';
import '../survey/survey_intro_screen.dart';

class SurveyHistoryScreen extends StatefulWidget {
  const SurveyHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SurveyHistoryScreen> createState() => _SurveyHistoryScreenState();
}

class _SurveyHistoryScreenState extends State<SurveyHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<SurveyProvider>().loadUserSurveyHistory(authProvider.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سجل الاستطلاعات'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _navigateToNewSurvey(),
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            tooltip: 'استطلاع جديد',
          ),
        ],
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, surveyProvider, child) {
          if (surveyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (surveyProvider.latestSurvey == null) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Survey Result
                _buildCurrentSurveyCard(context, surveyProvider.latestSurvey!),

                const SizedBox(height: 24),

                // Skin Type Analysis
                _buildSkinTypeAnalysis(context, surveyProvider.latestSurvey!),

                const SizedBox(height: 24),

                // Problems Analysis
                _buildProblemsAnalysis(context, surveyProvider.latestSurvey!),

                const SizedBox(height: 24),

                // Preferences Analysis
                _buildPreferencesAnalysis(context, surveyProvider.latestSurvey!),

                const SizedBox(height: 24),

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

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          )
              .animate()
              .scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 24),

          Text(
            'لم تكملي الاستطلاع بعد',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn()
              .slideY(begin: 0.3, curve: Curves.easeOut),

          const SizedBox(height: 12),

          Text(
            'ابدئي الاستطلاع الذكي لتحليل بشرتك والحصول على توصيات مخصصة لك',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 400))
              .fadeIn()
              .slideY(begin: 0.2, curve: Curves.easeOut),

          const SizedBox(height: 40),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _navigateToNewSurvey(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'ابدئي الاستطلاع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate(delay: const Duration(milliseconds: 600))
              .fadeIn()
              .slideY(begin: 0.3, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildCurrentSurveyCard(BuildContext context, Survey survey) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نتيجة الاستطلاع الحالية',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تم إجراؤه في ${_formatDate(survey.completedAt)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Skin Type Result
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نوع بشرتك',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSkinTypeDisplayName(survey.finalSkinType),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'الثقة',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      survey.confidencePercentage,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
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
    )
        .animate()
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildSkinTypeAnalysis(BuildContext context, Survey survey) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'تحليل نوع البشرة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...survey.skinAnalysis.entries.map((entry) {
            final skinType = entry.key;
            final score = entry.value;
            final percentage = (score / 100).clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getSkinTypeDisplayName(skinType),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${score.toInt()}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.getSkinTypeColor(skinType),
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 200))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildProblemsAnalysis(BuildContext context, Survey survey) {
    final problems = survey.problemsAnalysis;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                'تحليل المشاكل والاحتياجات',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (problems['needsMoisturizing'] == true)
            _buildProblemItem('تحتاج ترطيب إضافي', Icons.water_drop, AppColors.info),
          if (problems['needsLongLasting'] == true)
            _buildProblemItem('تحتاج منتجات طويلة الثبات', Icons.timer, AppColors.primary),
          if (problems['needsEnvironmentalProtection'] == true)
            _buildProblemItem('تحتاج حماية بيئية', Icons.shield, AppColors.success),
          if (problems['primaryProblem'] != null)
            _buildProblemItem(
              'المشكلة الأساسية: ${_getProblemDisplayName(problems['primaryProblem'])}',
              Icons.priority_high,
              AppColors.warning,
            ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 400))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildProblemItem(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesAnalysis(BuildContext context, Survey survey) {
    final preferences = survey.preferencesAnalysis;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'التفضيلات الشخصية',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (preferences['productType'] != null)
            _buildPreferenceItem('نوع المنتج المفضل', _getProductTypeDisplayName(preferences['productType'])),
          if (preferences['colorPreference'] != null)
            _buildPreferenceItem('تفضيل الألوان', _getColorPreferenceDisplayName(preferences['colorPreference'])),
          if (preferences['texturePreference'] != null)
            _buildPreferenceItem('تفضيل الملمس', _getTexturePreferenceDisplayName(preferences['texturePreference'])),
          if (preferences['occasionPreference'] != null)
            _buildPreferenceItem('المناسبة المفضلة', _getOccasionPreferenceDisplayName(preferences['occasionPreference'])),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildPreferenceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
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
        // Retake Survey Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _navigateToNewSurvey(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'إعادة الاستطلاع',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // View Recommendations Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.recommend, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'عرض التوصيات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
        .fadeIn();
  }

  // Helper methods for display names
  String _getSkinTypeDisplayName(String skinType) {
    switch (skinType) {
      case 'oily': return 'بشرة دهنية';
      case 'dry': return 'بشرة جافة';
      case 'combination': return 'بشرة مختلطة';
      case 'sensitive': return 'بشرة حساسة';
      case 'normal': return 'بشرة عادية';
      default: return 'غير محدد';
    }
  }

  String _getProblemDisplayName(String problem) {
    switch (problem) {
      case 'drying': return 'جفاف';
      case 'smudging': return 'تلطخ';
      case 'fading': return 'بهتان اللون';
      case 'environmental': return 'التأثر بالعوامل البيئية';
      case 'lifestyle': return 'تأثير نمط الحياة';
      default: return problem;
    }
  }

  String _getProductTypeDisplayName(String productType) {
    switch (productType) {
      case 'daily_lipstick': return 'أحمر شفاه يومي';
      case 'evening_lipstick': return 'أحمر شفاه للسهرات';
      case 'volume_mascara': return 'مسكرة للحجم';
      case 'dramatic_mascara': return 'مسكرة درامية';
      case 'lip_balm': return 'بلسم شفاه';
      case 'all_products': return 'مجموعة متكاملة';
      default: return productType;
    }
  }

  String _getColorPreferenceDisplayName(String colorPreference) {
    switch (colorPreference) {
      case 'natural': return 'ألوان طبيعية';
      case 'bold': return 'ألوان جريئة';
      case 'varied': return 'متنوعة';
      case 'classic': return 'كلاسيكية';
      default: return colorPreference;
    }
  }

  String _getTexturePreferenceDisplayName(String texturePreference) {
    switch (texturePreference) {
      case 'long_lasting': return 'طويل الثبات';
      case 'moisturizing': return 'مرطب';
      case 'glossy': return 'لامع';
      case 'balanced': return 'متوازن';
      case 'easy_application': return 'سهل التطبيق';
      default: return texturePreference;
    }
  }

  String _getOccasionPreferenceDisplayName(String occasionPreference) {
    switch (occasionPreference) {
      case 'professional': return 'مهني';
      case 'social': return 'اجتماعي';
      case 'special_events': return 'مناسبات خاصة';
      case 'daily': return 'يومي';
      case 'night_care': return 'العناية الليلية';
      default: return occasionPreference;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToNewSurvey() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SurveyIntroScreen(),
      ),
    );
  }
}