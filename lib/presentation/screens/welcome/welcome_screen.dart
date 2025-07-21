// lib/presentation/screens/welcome/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/survey_provider.dart';
import '../../navigation/bottom_navigation.dart';
import '../survey/survey_intro_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 60),

                // Logo and Title
                _buildHeader(context),

                const SizedBox(height: 60),

                // Welcome Message
                _buildWelcomeMessage(context),

                const SizedBox(height: 80),

                // Action Buttons
                _buildActionButtons(context),

                const Spacer(),

                // Features Preview
                _buildFeaturesPreview(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.face_retouching_natural,
            size: 50,
            color: AppColors.primary,
          ),
        )
            .animate()
            .scale(
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
        )
            .fadeIn(duration: const Duration(milliseconds: 600)),

        const SizedBox(height: 24),

        // App Name
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        )
            .animate(delay: const Duration(milliseconds: 200))
            .slideY(
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(duration: const Duration(milliseconds: 600)),

        const SizedBox(height: 8),

        // App Slogan
        Text(
          AppStrings.appSlogan,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 400))
            .slideY(
          begin: 0.2,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(duration: const Duration(milliseconds: 600)),
      ],
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
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
          Icon(
            Icons.psychology,
            size: 40,
            color: AppColors.primary.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.welcomeSubtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'سنساعدك في اكتشاف المنتجات المثالية لنوع بشرتك من خلال استطلاع ذكي مصمم خصيصاً لك',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 700));
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Button - Smart Survey
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _navigateToSurvey(context),
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
                const Icon(Icons.quiz, size: 24),
                const SizedBox(width: 12),
                Text(
                  AppStrings.startSurvey,
                  style: const TextStyle(
                    fontSize: 16,
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
            .fadeIn(duration: const Duration(milliseconds: 600)),

        const SizedBox(height: 16),

        // Secondary Button - Browse Products
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => _navigateToProducts(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 24),
                const SizedBox(width: 12),
                Text(
                  AppStrings.browseCatalog,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate(delay: const Duration(milliseconds: 1000))
            .slideY(
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(duration: const Duration(milliseconds: 600)),
      ],
    );
  }

  Widget _buildFeaturesPreview(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureItem(
            context,
            Icons.science,
            'تحليل علمي',
            'للبشرة',
          ),
        ),
        Expanded(
          child: _buildFeatureItem(
            context,
            Icons.recommend,
            'توصيات ذكية',
            'مخصصة لك',
          ),
        ),
        Expanded(
          child: _buildFeatureItem(
            context,
            Icons.verified,
            'منتجات أصلية',
            'عالية الجودة',
          ),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 1200))
        .slideY(
      begin: 0.2,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    )
        .fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _navigateToSurvey(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const SurveyIntroScreen(),
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
}
