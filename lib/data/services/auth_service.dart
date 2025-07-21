// lib/data/services/auth_service.dart
import 'dart:ui';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _currentUserIdKey = 'current_user_id';
  static const String _userDataKey = 'user_data';

  // تسجيل مستخدم جديد
  static Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final user = ParseUser(email, password, email);

      // إضافة بيانات إضافية
      user.set('fullName', fullName);
      user.set('email', email);
      if (phone != null && phone.isNotEmpty) {
        user.set('phone', phone);
      }
      user.set('isActive', true);
      user.set('profileCompleted', false);

      final response = await user.signUp();

      if (response.success) {
        await _saveUserData(user);
        return AuthResult.success(user);
      } else {
        return AuthResult.error(_getErrorMessage(response.error));
      }
    } catch (e) {
      return AuthResult.error('خطأ في إنشاء الحساب: $e');
    }
  }

  // تسجيل الدخول
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = ParseUser(email, password, null);
      final response = await user.login();

      if (response.success) {
        await _saveUserData(response.result as ParseUser);
        return AuthResult.success(response.result as ParseUser);
      } else {
        return AuthResult.error(_getErrorMessage(response.error));
      }
    } catch (e) {
      return AuthResult.error('خطأ في تسجيل الدخول: $e');
    }
  }

  // تسجيل الخروج
  static Future<bool> signOut() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        await user.logout();
      }

      // مسح البيانات المحلية
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserIdKey);
      await prefs.remove(_userDataKey);

      return true;
    } catch (e) {
      print('❌ Error signing out: $e');
      return false;
    }
  }

  // التحقق من حالة تسجيل الدخول
  static Future<bool> isSignedIn() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  // الحصول على المستخدم الحالي
  static Future<ParseUser?> getCurrentUser() async {
    try {
      return await ParseUser.currentUser() as ParseUser?;
    } catch (e) {
      return null;
    }
  }

  // إعادة تعيين كلمة المرور
  static Future<AuthResult> resetPassword(String email) async {
    try {
      final user = ParseUser(null, null, email);
      final response = await user.requestPasswordReset();

      if (response.success) {
        return AuthResult.success(null);
      } else {
        return AuthResult.error(_getErrorMessage(response.error));
      }
    } catch (e) {
      return AuthResult.error('خطأ في إرسال رابط إعادة التعيين: $e');
    }
  }

  // تحديث الملف الشخصي
  static Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? skinType,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final user = ParseUser(null, null, null)..objectId = userId;

      if (fullName != null) user.set('fullName', fullName);
      if (phone != null) user.set('phone', phone);
      if (skinType != null) user.set('skinType', skinType);
      if (preferences != null) user.set('preferences', preferences);

      final response = await user.save();

      if (response.success) {
        await _saveUserData(user);
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  // حفظ بيانات المستخدم محلياً
  static Future<void> _saveUserData(ParseUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserIdKey, user.objectId ?? '');

      final userData = {
        'objectId': user.objectId,
        'fullName': user.get<String>('fullName') ?? '',
        'email': user.get<String>('email') ?? '',
        'phone': user.get<String>('phone') ?? '',
        'skinType': user.get<String>('skinType') ?? '',
        'profileCompleted': user.get<bool>('profileCompleted') ?? false,
      };

      await prefs.setString(_userDataKey, userData.toString());
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // الحصول على معرف المستخدم المحفوظ
  static Future<String?> getSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserIdKey);
    } catch (e) {
      return null;
    }
  }

  // التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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

    switch (error.code) {
      case ParseError.usernameTaken:
      case ParseError.emailTaken:
        return 'البريد الإلكتروني مستخدم بالفعل';
      case ParseError.invalidEmailAddress:
        return 'البريد الإلكتروني غير صالح';
      case ParseError.objectNotFound:
        return 'البيانات المطلوبة غير موجودة';
      case ParseError.invalidEmailAddress:
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case ParseError.connectionFailed:
        return 'فشل في الاتصال بالخادم';
      default:
        return error.message ?? 'حدث خطأ غير معروف';
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