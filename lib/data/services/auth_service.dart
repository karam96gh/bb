// lib/data/services/auth_service.dart - مُصلح
import 'dart:ui';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _currentUserIdKey = 'current_user_id';
  static const String _userDataKey = 'user_data';

  // تسجيل مستخدم جديد - مُحسن
  static Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      print('🔐 Creating new user: $email');

      final user = ParseUser(email, password, email);

      // إضافة بيانات إضافية
      user.set('fullName', fullName);
      user.set('email', email);
      if (phone != null && phone.isNotEmpty) {
        user.set('phone', phone);
      }
      user.set('isActive', true);
      user.set('profileCompleted', false);
      user.set('skinType', '');
      user.set('preferences', {});

      final response = await user.signUp();

      if (response.success) {
        await _saveUserData(user);
        print('✅ User created successfully: ${user.objectId}');
        return AuthResult.success(user);
      } else {
        final errorMessage = _getErrorMessage(response.error);
        print('❌ Sign up failed: $errorMessage');
        return AuthResult.error(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'خطأ في إنشاء الحساب: $e';
      print('❌ Sign up error: $errorMessage');
      return AuthResult.error(errorMessage);
    }
  }

  // تسجيل الدخول - مُحسن
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Signing in user: $email');

      final user = ParseUser(email, password, null);
      final response = await user.login();

      if (response.success) {
        final loggedInUser = response.result as ParseUser;
        await _saveUserData(loggedInUser);
        print('✅ User signed in successfully: ${loggedInUser.objectId}');
        return AuthResult.success(loggedInUser);
      } else {
        final errorMessage = _getErrorMessage(response.error);
        print('❌ Sign in failed: $errorMessage');
        return AuthResult.error(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'خطأ في تسجيل الدخول: $e';
      print('❌ Sign in error: $errorMessage');
      return AuthResult.error(errorMessage);
    }
  }

  // تسجيل الخروج - مُحسن
  static Future<bool> signOut() async {
    try {
      print('🔐 Signing out user');

      final user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        await user.logout();
        print('✅ User logged out from server');
      }

      // مسح البيانات المحلية
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserIdKey);
      await prefs.remove(_userDataKey);

      print('✅ Local data cleared');
      return true;
    } catch (e) {
      print('❌ Error signing out: $e');
      return false;
    }
  }

  // التحقق من حالة تسجيل الدخول - مُحسن
  static Future<bool> isSignedIn() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      final isSignedIn = user != null;
      print('🔍 User signed in status: $isSignedIn');
      return isSignedIn;
    } catch (e) {
      print('❌ Error checking sign in status: $e');
      return false;
    }
  }

  // الحصول على المستخدم الحالي - مُحسن
  static Future<ParseUser?> getCurrentUser() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        print('✅ Current user found: ${user.objectId}');
        // تحديث البيانات المحلية
        await _saveUserData(user);
      } else {
        print('ℹ️ No current user found');
      }
      return user;
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  // إعادة تعيين كلمة المرور
  static Future<AuthResult> resetPassword(String email) async {
    try {
      print('🔐 Requesting password reset for: $email');

      final user = ParseUser(null, null, email);
      final response = await user.requestPasswordReset();

      if (response.success) {
        print('✅ Password reset email sent');
        return AuthResult.success(null);
      } else {
        final errorMessage = _getErrorMessage(response.error);
        print('❌ Password reset failed: $errorMessage');
        return AuthResult.error(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'خطأ في إرسال رابط إعادة التعيين: $e';
      print('❌ Password reset error: $errorMessage');
      return AuthResult.error(errorMessage);
    }
  }

  // تحديث الملف الشخصي - مُحسن
  static Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? skinType,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      print('🔐 Updating profile for user: $userId');

      final user = ParseUser(null, null, null)..objectId = userId;

      if (fullName != null) {
        user.set('fullName', fullName);
        print('  - Updated fullName: $fullName');
      }
      if (phone != null) {
        user.set('phone', phone);
        print('  - Updated phone: $phone');
      }
      if (skinType != null) {
        user.set('skinType', skinType);
        print('  - Updated skinType: $skinType');
      }
      if (preferences != null) {
        user.set('preferences', preferences);
        print('  - Updated preferences');
      }

      // تحديث تاريخ آخر تعديل
      user.set('updatedAt', DateTime.now().toIso8601String());

      final response = await user.save();

      if (response.success) {
        await _saveUserData(user);
        print('✅ Profile updated successfully');
        return true;
      } else {
        print('❌ Profile update failed: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  // حفظ بيانات المستخدم محلياً - مُحسن
  static Future<void> _saveUserData(ParseUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // حفظ معرف المستخدم
      final userId = user.objectId ?? '';
      await prefs.setString(_currentUserIdKey, userId);

      // حفظ بيانات المستخدم
      final userData = {
        'objectId': userId,
        'fullName': user.get<String>('fullName') ?? '',
        'email': user.get<String>('email') ?? '',
        'phone': user.get<String>('phone') ?? '',
        'skinType': user.get<String>('skinType') ?? '',
        'profileCompleted': user.get<bool>('profileCompleted') ?? false,
        'isActive': user.get<bool>('isActive') ?? true,
        'preferences': user.get<Map<String, dynamic>>('preferences') ?? {},
      };

      // تحويل البيانات إلى JSON string للحفظ
      final userDataJson = userData.toString();
      await prefs.setString(_userDataKey, userDataJson);

      print('💾 User data saved locally');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // الحصول على معرف المستخدم المحفوظ
  static Future<String?> getSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserIdKey);
      print('📱 Saved user ID: ${userId ?? "none"}');
      return userId;
    } catch (e) {
      print('❌ Error getting saved user ID: $e');
      return null;
    }
  }

  // الحصول على بيانات المستخدم المحفوظة
  static Future<Map<String, dynamic>?> getSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);

      if (userDataString != null && userDataString.isNotEmpty) {
        // هذا مثال بسيط - في التطبيق الحقيقي يفضل استخدام JSON
        print('📱 User data found in local storage');
        return {}; // يمكن تحسين هذا لاحقاً
      }

      return null;
    } catch (e) {
      print('❌ Error getting saved user data: $e');
      return null;
    }
  }

  // التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // التحقق من قوة كلمة المرور
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.length < 6) {
      return PasswordStrength.weak;
    } else if (password.length < 8) {
      return PasswordStrength.medium;
    } else if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      return PasswordStrength.strong;
    } else {
      return PasswordStrength.medium;
    }
  }

  // تحويل رسائل الخطأ
  static String _getErrorMessage(ParseError? error) {
    if (error == null) return 'حدث خطأ غير معروف';

    print('📱 Parse error code: ${error.code}, message: ${error.message}');

    switch (error.code) {
      case ParseError.usernameTaken:
      case ParseError.emailTaken:
        return 'البريد الإلكتروني مستخدم بالفعل';
      case ParseError.invalidEmailAddress:
        return 'البريد الإلكتروني غير صالح';
      case ParseError.objectNotFound:
        return 'البيانات المطلوبة غير موجودة';
      case ParseError.invalidSessionToken:
        return 'انتهت صلاحية جلسة العمل، يرجى تسجيل الدخول مرة أخرى';
      case ParseError.connectionFailed:
        return 'فشل في الاتصال بالخادم';
      case 101: // Invalid username/password
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      default:
        return error.message ?? 'حدث خطأ غير معروف';
    }
  }

  // تنظيف البيانات المحلية
  static Future<void> clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserIdKey);
      await prefs.remove(_userDataKey);
      print('🗑️ Local auth data cleared');
    } catch (e) {
      print('❌ Error clearing local data: $e');
    }
  }
}

// نتيجة العملية
class AuthResult {
  final bool isSuccess;
  final ParseUser? user;
  final String? error;

  AuthResult._(this.isSuccess, this.user, this.error);

  factory AuthResult.success(ParseUser? user) => AuthResult._(true, user, null);
  factory AuthResult.error(String error) => AuthResult._(false, null, error);
}

// قوة كلمة المرور
enum PasswordStrength {
  weak,
  medium,
  strong,
}

extension PasswordStrengthExtension on PasswordStrength {
  String get text {
    switch (this) {
      case PasswordStrength.weak:
        return 'ضعيفة';
      case PasswordStrength.medium:
        return 'متوسطة';
      case PasswordStrength.strong:
        return 'قوية';
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.weak:
        return const Color(0xFFF44336); // أحمر
      case PasswordStrength.medium:
        return const Color(0xFFFF9800); // برتقالي
      case PasswordStrength.strong:
        return const Color(0xFF4CAF50); // أخضر
    }
  }
}