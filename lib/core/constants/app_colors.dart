import 'package:flutter/material.dart';

import 'app_constants.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE91E63); // وردي أساسي
  static const Color primaryLight = Color(0xFFF8BBD9);
  static const Color primaryDark = Color(0xFFAD1457);

  // Secondary Colors
  static const Color secondary = Color(0xFF673AB7); // بنفسجي
  static const Color secondaryLight = Color(0xFFD1C4E9);
  static const Color secondaryDark = Color(0xFF512DA8);

  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1D1B20);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Skin Type Colors
  static const Color oilySkinColor = Color(0xFF4CAF50);
  static const Color drySkinColor = Color(0xFF2196F3);
  static const Color combinationSkinColor = Color(0xFFFF9800);
  static const Color sensitiveSkinColor = Color(0xFFF44336);
  static const Color normalSkinColor = Color(0xFF9C27B0);

  // Product Category Colors
  static const Color lipstickColor = Color(0xFFE91E63);
  static const Color mascaraColor = Color(0xFF795548);
  static const Color lipBalmColor = Color(0xFF4CAF50);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFF0F0F0)],
  );

  // Helper Methods
  static Color getSkinTypeColor(String skinType) {
    switch (skinType.toLowerCase()) {
      case AppConstants.oilySkin:
        return oilySkinColor;
      case AppConstants.drySkin:
        return drySkinColor;
      case AppConstants.combinationSkin:
        return combinationSkinColor;
      case AppConstants.sensitiveSkin:
        return sensitiveSkinColor;
      case AppConstants.normalSkin:
        return normalSkinColor;
      default:
        return normalSkinColor;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case AppConstants.lipstickCategory:
        return lipstickColor;
      case AppConstants.mascaraCategory:
        return mascaraColor;
      case AppConstants.lipBalmCategory:
        return lipBalmColor;
      default:
        return primary;
    }
  }
}
