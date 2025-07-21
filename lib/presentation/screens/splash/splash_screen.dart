// lib/presentation/screens/splash/splash_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../navigation/bottom_navigation.dart';
import '../welcome/welcome_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isFirstRun;
  final bool isAuthenticated;

  const SplashScreen({
    Key? key,
    required this.isFirstRun,
    this.isAuthenticated = false,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _navigateAfterSplash();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Widget destination;

      if (widget.isFirstRun) {
        // First time opening the app
        destination = const WelcomeScreen();
      } else if (widget.isAuthenticated) {
        // User is already logged in
        destination = const BottomNavigation();
      } else {
        // User needs to log in
        destination = const LoginScreen();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                size: 60,
                color: AppColors.primary,
              ),
            )
                .animate()
                .scale(
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
            )
                .fadeIn(duration: const Duration(milliseconds: 600)),

            const SizedBox(height: 32),

            // App Name
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            )
                .animate(delay: const Duration(milliseconds: 400))
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            )
                .animate(delay: const Duration(milliseconds: 600))
                .slideY(
              begin: 0.2,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            )
                .fadeIn(duration: const Duration(milliseconds: 600)),

            const SizedBox(height: 60),

            // Loading Animation
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
                strokeWidth: 3,
              ),
            )
                .animate(delay: const Duration(milliseconds: 800))
                .fadeIn(duration: const Duration(milliseconds: 400)),

            const SizedBox(height: 16),

            // Loading Text
            Text(
              _getLoadingText(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            )
                .animate(delay: const Duration(milliseconds: 1000))
                .fadeIn(duration: const Duration(milliseconds: 400)),
          ],
        ),
      ),
    );
  }

  String _getLoadingText() {
    if (widget.isFirstRun) {
      return 'مرحباً بك في BeautyMatch...';
    } else if (widget.isAuthenticated) {
      return 'أهلاً بك مجدداً...';
    } else {
      return AppStrings.loading;
    }
  }
}