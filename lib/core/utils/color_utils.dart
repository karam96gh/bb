// lib/core/utils/color_utils.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
class ColorUtils {
  // تحويل HEX إلى Color
  static Color hexToColor(String hexString) {
    try {
      // إزالة # إذا كانت موجودة
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      // إرجاع لون افتراضي في حالة الخطأ
      return Colors.grey;
    }
  }

  // تحويل Color إلى HEX
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // الحصول على لون متدرج
  static Color getLighterColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  // الحصول على لون أغمق
  static Color getDarkerColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  // التحقق من تباين اللون
  static bool hasGoodContrast(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final darkest = luminance1 > luminance2 ? luminance2 : luminance1;

    final contrast = (brightest + 0.05) / (darkest + 0.05);

    // WCAG AA standards require a contrast ratio of at least 4.5:1
    return contrast >= 4.5;
  }

  // الحصول على لون النص المناسب (أبيض أو أسود)
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // مزج لونين
  static Color blendColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0);

    final r = (color1.red * (1 - ratio) + color2.red * ratio).round();
    final g = (color1.green * (1 - ratio) + color2.green * ratio).round();
    final b = (color1.blue * (1 - ratio) + color2.blue * ratio).round();
    final a = (color1.alpha * (1 - ratio) + color2.alpha * ratio).round();

    return Color.fromARGB(a, r, g, b);
  }

  // إنشاء تدرج لوني
  static LinearGradient createGradient(
      Color startColor,
      Color endColor, {
        AlignmentGeometry begin = Alignment.topLeft,
        AlignmentGeometry end = Alignment.bottomRight,
      }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, endColor],
    );
  }

  // ألوان المزاج
  static Color getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'سعيد':
        return Colors.yellow[700]!;
      case 'calm':
      case 'هادئ':
        return Colors.blue[400]!;
      case 'energetic':
      case 'نشيط':
        return Colors.orange[600]!;
      case 'romantic':
      case 'رومانسي':
        return Colors.pink[400]!;
      case 'professional':
      case 'مهني':
        return Colors.grey[700]!;
      case 'elegant':
      case 'أنيق':
        return Colors.black87;
      default:
        return Colors.grey[500]!;
    }
  }

  // ألوان الفصول
  static Color getSeasonColor(String season) {
    switch (season.toLowerCase()) {
      case 'spring':
      case 'ربيع':
        return Colors.green[400]!;
      case 'summer':
      case 'صيف':
        return Colors.orange[500]!;
      case 'autumn':
      case 'fall':
      case 'خريف':
        return Colors.brown[400]!;
      case 'winter':
      case 'شتاء':
        return Colors.blue[600]!;
      default:
        return Colors.grey[500]!;
    }
  }

  // تحويل لون إلى Material Color
  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // الحصول على لون عشوائي
  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  // ألوان متدرجة للبيانات
  static List<Color> getDataColors(int count) {
    if (count <= 0) return [];

    final List<Color> baseColors = [
      Colors.blue[500]!,
      Colors.green[500]!,
      Colors.orange[500]!,
      Colors.purple[500]!,
      Colors.red[500]!,
      Colors.teal[500]!,
      Colors.indigo[500]!,
      Colors.pink[500]!,
    ];

    if (count <= baseColors.length) {
      return baseColors.take(count).toList();
    }

    // إنشاء ألوان إضافية بتنويع الدرجات
    final List<Color> colors = List.from(baseColors);
    for (int i = baseColors.length; i < count; i++) {
      final baseColor = baseColors[i % baseColors.length];
      final variation = (i / baseColors.length) * 0.3;
      colors.add(getLighterColor(baseColor, variation));
    }

    return colors;
  }

  // تحليل لون البشرة (بسيط)
  static Map<String, dynamic> analyzeSkinTone(Color skinColor) {
    final hsl = HSLColor.fromColor(skinColor);

    String undertone;
    if (hsl.hue >= 10 && hsl.hue <= 45) {
      undertone = 'warm'; // دافئ
    } else if (hsl.hue >= 180 && hsl.hue <= 240) {
      undertone = 'cool'; // بارد
    } else {
      undertone = 'neutral'; // محايد
    }

    String depth;
    if (hsl.lightness < 0.3) {
      depth = 'deep'; // غامق
    } else if (hsl.lightness < 0.6) {
      depth = 'medium'; // متوسط
    } else {
      depth = 'light'; // فاتح
    }

    return {
      'undertone': undertone,
      'depth': depth,
      'hue': hsl.hue,
      'saturation': hsl.saturation,
      'lightness': hsl.lightness,
    };
  }
}

