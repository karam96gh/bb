// lib/presentation/screens/profile/profile_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/providers/uth_provider.dart';
import '../survey/survey_intro_screen.dart';
import 'survey_history_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.profile),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return _buildUnauthenticatedView(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(context, authProvider),

                const SizedBox(height: 32),

                // Menu Items
                _buildMenuItem(
                  context,
                  Icons.quiz_outlined,
                  'إعادة الاستطلاع',
                  'احصلي على توصيات جديدة',
                      () => _navigateToSurvey(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.history,
                  'سجل الاستطلاعات',
                  'عرض نتائج الاستطلاعات السابقة',
                      () => _navigateToSurveyHistory(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.favorite_outline,
                  'المفضلة',
                  'منتجاتك المحفوظة',
                      () => _showComingSoon(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.location_on_outlined,
                  'العناوين',
                  'إدارة عناوين التوصيل',
                      () => _showComingSoon(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.notifications_outlined,
                  'الإشعارات',
                  'إعدادات الإشعارات',
                      () => _showComingSoon(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.person_outline,
                  'تعديل الملف الشخصي',
                  'تحديث بياناتك الشخصية',
                      () => _showEditProfile(context, authProvider),
                ),

                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  'المساعدة',
                  'الأسئلة الشائعة والدعم',
                      () => _showComingSoon(context),
                ),

                _buildMenuItem(
                  context,
                  Icons.info_outline,
                  'حول التطبيق',
                  'معلومات التطبيق والنسخة',
                      () => _showAboutApp(context),
                ),

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _showLogoutDialog(context, authProvider),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authProvider.isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.error,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('تسجيل الخروج'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'غير مسجل دخول',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'سجلي دخولك للوصول إلى ملفك الشخصي وإدارة حسابك',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _navigateToLogin(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider authProvider) {
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
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              authProvider.displayName.isNotEmpty
                  ? authProvider.displayName[0].toUpperCase()
                  : 'م',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authProvider.displayName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authProvider.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (authProvider.skinType.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.getSkinTypeColor(authProvider.skinType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getSkinTypeDisplayName(authProvider.skinType),
                style: TextStyle(
                  color: AppColors.getSkinTypeColor(authProvider.skinType),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.onSurfaceVariant,
        ),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

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

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _navigateToSurvey(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SurveyIntroScreen(),
      ),
    );
  }

  void _navigateToSurveyHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SurveyHistoryScreen(),
      ),
    );
  }

  void _showEditProfile(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildEditProfileSheet(context, authProvider),
    );
  }

  Widget _buildEditProfileSheet(BuildContext context, AuthProvider authProvider) {
    final nameController = TextEditingController(text: authProvider.fullName);
    final phoneController = TextEditingController(text: authProvider.phone);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تعديل الملف الشخصي',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await authProvider.updateProfile(
                        fullName: nameController.text,
                        phone: phoneController.text,
                      );

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'تم تحديث الملف الشخصي بنجاح'
                                  : 'فشل في تحديث الملف الشخصي',
                            ),
                            backgroundColor: success ? AppColors.success : AppColors.error,
                          ),
                        );
                      }
                    },
                    child: const Text('حفظ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكدة من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await authProvider.signOut();

              if (context.mounted && success) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              }
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('هذه الميزة ستكون متاحة قريباً'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.face_retouching_natural,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(AppStrings.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appSlogan,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text('الإصدار: 1.0.0'),
            const SizedBox(height: 8),
            const Text('تطبيق ذكي لتوصيات منتجات التجميل باستخدام الذكاء الاصطناعي'),
            const SizedBox(height: 16),
            Text(
              '© 2024 BeautyMatch. جميع الحقوق محفوظة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
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