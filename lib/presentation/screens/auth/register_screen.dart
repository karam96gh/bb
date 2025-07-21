// lib/presentation/screens/auth/register_screen.dart
import 'package:beauty/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/uth_provider.dart';
import '../survey/survey_intro_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    const SizedBox(height: 20),

                    // Header
                    _buildHeader(context),

                    const SizedBox(height: 40),

                    // Full Name Field
                    _buildFullNameField(),

                    const SizedBox(height: 20),

                    // Email Field
                    _buildEmailField(),

                    const SizedBox(height: 20),

                    // Phone Field
                    _buildPhoneField(),

                    const SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(),

                    const SizedBox(height: 20),

                    // Confirm Password Field
                    _buildConfirmPasswordField(),

                    const SizedBox(height: 20),

                    // Terms & Conditions
                    _buildTermsCheckbox(),

                    const SizedBox(height: 32),

                    // Register Button
                    _buildRegisterButton(context, authProvider),

                    const SizedBox(height: 24),

                    // Sign In Link
                    _buildSignInLink(context),

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
          'إنشاء حساب جديد',
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
          'انضمي إلينا واكتشفي عالم الجمال',
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

  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاسم الكامل',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fullNameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'ادخلي اسمك الكامل',
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الاسم الكامل مطلوب';
            }
            if (value.length < 2) {
              return 'الاسم يجب أن يكون حرفين على الأقل';
            }
            return null;
          },
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 300))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
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

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم الهاتف (اختياري)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'ادخلي رقم هاتفك',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (value.length < 10) {
                return 'رقم الهاتف غير صالح';
              }
            }
            return null;
          },
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
          textInputAction: TextInputAction.next,
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
          onChanged: (value) {
            setState(() {}); // To update password strength indicator
          },
        ),
        const SizedBox(height: 8),
        // Password Strength Indicator
        if (_passwordController.text.isNotEmpty)
          _buildPasswordStrengthIndicator(),
      ],
    )
        .animate(delay: const Duration(milliseconds: 600))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = context.read<AuthProvider>().checkPasswordStrength(_passwordController.text);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: strength.color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'قوة كلمة المرور: ${strength.text}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: strength.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تأكيد كلمة المرور',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'أعيدي إدخال كلمة المرور',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.onSurfaceVariant,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'تأكيد كلمة المرور مطلوب';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleRegister(),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 700))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'أوافق على ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: 'شروط الاستخدام',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' و ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: 'سياسة الخصوصية',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    )
        .animate(delay: const Duration(milliseconds: 800))
        .slideY(
      begin: 0.2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildRegisterButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authProvider.isLoading || !_acceptTerms ? null : _handleRegister,
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
          'إنشاء الحساب',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    )
        .animate(delay: const Duration(milliseconds: 900))
        .slideY(
      begin: 0.3,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    )
        .fadeIn();
  }

  Widget _buildSignInLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لديك حساب بالفعل؟ ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => _navigateToLogin(),
            child: Text(
              'تسجيل الدخول',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 1000))
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

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على شروط الاستخدام'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.signUp(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
    );

    if (success && mounted) {
      // Navigate to survey intro
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SurveyIntroScreen(),
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
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