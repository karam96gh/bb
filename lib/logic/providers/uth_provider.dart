// lib/logic/providers/auth_provider.dart (Fixed)
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Authentication State
  bool _isAuthenticated = false;
  ParseUser? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  // User Data
  String _userId = '';
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _skinType = '';
  bool _profileCompleted = false;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  ParseUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  String get userId => _userId;
  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get skinType => _skinType;
  bool get profileCompleted => _profileCompleted;

  // Initialize authentication state
  Future<void> initialize() async {
    if (_isInitialized) return;

    _setLoading(true);

    try {
      final isSignedIn = await AuthService.isSignedIn();
      if (isSignedIn) {
        final user = await AuthService.getCurrentUser();
        if (user != null) {
          _setUserData(user);
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      print('❌ Error initializing auth: $e');
    }

    _isInitialized = true;
    _setLoading(false);
  }

  String get effectiveUserId {
    if (isAuthenticated && _userId.isNotEmpty) {
      return _userId;
    }
    // إنشاء guest user ID مؤقت
    return 'guest_${DateTime.now().millisecondsSinceEpoch}';
  }
  // Sign up new user
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await AuthService.signUp(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );

      if (result.isSuccess && result.user != null) {
        _setUserData(result.user!);
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      } else {
        _error = result.error;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'خطأ في إنشاء الحساب: $e';
      _setLoading(false);
      return false;
    }
  }

  // Sign in existing user
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await AuthService.signIn(
        email: email,
        password: password,
      );

      if (result.isSuccess && result.user != null) {
        _setUserData(result.user!);
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      } else {
        _error = result.error;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'خطأ في تسجيل الدخول: $e';
      _setLoading(false);
      return false;
    }
  }

  // Sign out current user
  Future<bool> signOut() async {
    _setLoading(true);

    try {
      final success = await AuthService.signOut();
      if (success) {
        _clearUserData();
        _isAuthenticated = false;
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _error = 'خطأ في تسجيل الخروج: $e';
      _setLoading(false);
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await AuthService.resetPassword(email);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _error = result.error;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'خطأ في إرسال رابط إعادة التعيين: $e';
      _setLoading(false);
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? skinType,
    Map<String, dynamic>? preferences,
  }) async {
    if (!_isAuthenticated || _userId.isEmpty) return false;

    _setLoading(true);
    _clearError();

    try {
      final success = await AuthService.updateProfile(
        userId: _userId,
        fullName: fullName,
        phone: phone,
        skinType: skinType,
        preferences: preferences,
      );

      if (success) {
        // Update local data
        if (fullName != null) _fullName = fullName;
        if (phone != null) _phone = phone;
        if (skinType != null) _skinType = skinType;

        // Refresh user data
        final user = await AuthService.getCurrentUser();
        if (user != null) {
          _setUserData(user);
        }
      } else {
        _error = 'فشل في تحديث الملف الشخصي';
      }

      _setLoading(false);
      return success;
    } catch (e) {
      _error = 'خطأ في تحديث الملف الشخصي: $e';
      _setLoading(false);
      return false;
    }
  }

  // Mark profile as completed
  Future<bool> completeProfile({
    required String skinType,
    Map<String, dynamic>? preferences,
  }) async {
    final success = await updateProfile(
      skinType: skinType,
      preferences: preferences,
    );

    if (success) {
      _profileCompleted = true;
      await AuthService.updateProfile(
        userId: _userId,
        preferences: {'profileCompleted': true},
      );
      // Don't call notifyListeners here as it's already called in _setUserData
    }

    return success;
  }

  // Set user data from ParseUser (fixed - avoid calling during build)
  void _setUserData(ParseUser user) {
    _currentUser = user;
    _userId = user.objectId ?? '';
    _fullName = user.get<String>('fullName') ?? '';
    _email = user.get<String>('email') ?? '';
    _phone = user.get<String>('phone') ?? '';
    _skinType = user.get<String>('skinType') ?? '';
    _profileCompleted = user.get<bool>('profileCompleted') ?? false;

    // Only notify listeners if not currently building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear user data (fixed - avoid calling during build)
  void _clearUserData() {
    _currentUser = null;
    _userId = '';
    _fullName = '';
    _email = '';
    _phone = '';
    _skinType = '';
    _profileCompleted = false;

    // Only notify listeners if not currently building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set loading state (fixed - avoid calling during build)
  void _setLoading(bool loading) {
    _isLoading = loading;

    // Only notify listeners if not currently building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear error (fixed - avoid calling during build)
  void _clearError() {
    _error = null;

    // Only notify listeners if not currently building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Check if user needs to complete profile
  bool get needsProfileCompletion => _isAuthenticated && !_profileCompleted;

  // Get display name
  String get displayName {
    if (_fullName.isNotEmpty) return _fullName;
    if (_email.isNotEmpty) return _email.split('@').first;
    return 'مستخدم';
  }

  // Validate email format
  bool isValidEmail(String email) {
    return AuthService.isValidEmail(email);
  }

  // Check password strength
  PasswordStrength checkPasswordStrength(String password) {
    return AuthService.checkPasswordStrength(password);
  }
}