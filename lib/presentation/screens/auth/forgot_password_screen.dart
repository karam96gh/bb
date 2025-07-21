// lib/presentation/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../logic/providers/uth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgotPasswordScreen({Key? key, this.email}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (_emailSent) {
              return _buildSuccessView(context);
            }

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

                    const SizedBox(height: 32),

                    // Send Button
                    _buildSendButton(context, authProvider),

                    const SizedBox(height: 20),

                    // Error Message
                    if (authProvider.error != null)
                      _buildErrorMessage(authProvider.error!),

                    const SizedBox(height: 40),

                    // Instructions
                    _buildInstructions(context),
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
        // Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.lock_reset,
            size: 40,
            color: AppColors.primary,
          ),
        )
            .animate()
            .scale(
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
        )
            .fadeIn(),

        const SizedBox(height: 24),

        // Title
        Text(
          'نسيت كلمة المرور؟',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        )
            .animate(delay: const Duration(milliseconds: 200))
            .slideX(
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        )
            .fadeIn(),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'لا تقلقي! ادخلي بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        )
            .animate(delay: const Duration(milliseconds: 400))
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
          textInputAction: TextInputAction.done,
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
          onFieldSubmitted: (_) => _handleSendResetLink(),
        ),
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

  Widget _buildSendButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : _handleSendResetLink,
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
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20),
            const SizedBox(width: 8),
            const Text(
              'إرسال رابط الاستعادة',
              style: TextStyle(
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

  Widget _buildInstructions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.info.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'تعليمات مهمة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstruction('1. تأكدي من كتابة البريد الإلكتروني الصحيح'),
          _buildInstruction('2. تحققي من صندوق الوارد وملف الرسائل غير المرغوب فيها'),
          _buildInstruction('3. قد يستغرق وصول الرسالة بضع دقائق'),
          _buildInstruction('4. الرابط صالح لمدة 24 ساعة فقط'),
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

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.info,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.mark_email_read,
              size: 80,
              color: AppColors.success,
            ),
          )
              .animate()
              .scale(
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
          )
              .fadeIn(),

          const SizedBox(height: 32),

          // Success Title
          Text(
            'تم الإرسال بنجاح!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 200))
              .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          )
              .fadeIn(),

          const SizedBox(height: 16),

          // Success Message
          Text(
            'تم إرسال رابط إعادة تعيين كلمة المرور إلى:\n${_emailController.text}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 400))
              .slideY(
            begin: 0.2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          )
              .fadeIn(),

          const SizedBox(height: 40),

          // Action Buttons
          Column(
            children: [
              // Open Email App Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // يمكن إضافة فتح تطبيق البريد الإلكتروني هنا
                  },
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
                      Icon(Icons.email, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'فتح البريد الإلكتروني',
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

              // Back to Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'العودة لتسجيل الدخول',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Resend Link
              TextButton(
                onPressed: () {
                  setState(() {
                    _emailSent = false;
                  });
                },
                child: Text(
                  'إعادة إرسال الرابط',
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
            begin: 0.3,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          )
              .fadeIn(),
        ],
      ),
    );
  }

  void _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.resetPassword(_emailController.text.trim());

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }
}