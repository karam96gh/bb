// lib/presentation/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/uth_provider.dart';
import '../../navigation/bottom_navigation.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Header
                    _buildHeader(context),

                    const SizedBox(height: 60),

                    // Email Field
                    _buildEmailField(),

                    const SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(),

                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password
                    _buildOptionsRow(),

                    const SizedBox(height: 32),

                    // Login Button
                    _buildLoginButton(context, authProvider),

                    const SizedBox(height: 24),

                    // Divider
                    _buildDivider(),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    _buildSignUpLink(context),

                    const SizedBox(height: 20),

                    // Error Message
                    if (authProvider.error != null)
                      _buildErrorMessage(authProvider.error!),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.onSurface,
          ),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerRight,
        ),

        const SizedBox(height: 20),

        // Title
        Text(
          'أهلاً بك مجدداً!',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        )
            .animate()
            .slideX(
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'سجلي دخولك لمتابعة رحلة الجمال',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        )
            .animate(delay: const Duration(milliseconds: 200))
            .slideX(
          begin: 0.2,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البريد الإلكتروني',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'ادخلي بريدك الإلكتروني',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'البريد الإلكتروني مطلوب';
            }
            if (!context.read<AuthProvider>().isValidEmail(value)) {
              return 'البريد الإلكتروني غير صالح';
            }
            return null;
          },
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 400))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'كلمة المرور',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'ادخلي كلمة المرور',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.onSurfaceVariant,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'كلمة المرور مطلوبة';
            }
            if (value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 500))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildOptionsRow() {
    return Row(
      children: [
        // Remember Me
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppColors.primary,
            ),
            Text(
              'تذكرني',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),

        const Spacer(),

        // Forgot Password
        TextButton(
          onPressed: () => _navigateToForgotPassword(),
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideY(
      begin: 0.2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'تسجيل الدخول',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    )
        .animate(delay: const Duration(milliseconds: 700))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أو',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 800))
        .fadeIn();
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ليس لديك حساب؟ ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => _navigateToRegister(),
            child: Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 900))
        .slideY(
      begin: 0.2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(),
        ),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const RegisterScreen(),
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

  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }
}