// lib/core/utils/calculation_utils.dart
import 'dart:math' as math;
class CalculationUtils {
  // تحويل آمن من dynamic إلى int
  static int safeIntFromDynamic(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  // تحويل آمن من dynamic إلى double
  static double safeDoubleFromDynamic(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;

    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  // تحويل Map<String, dynamic> إلى Map<String, int>
  static Map<String, int> safeIntMapFromDynamic(dynamic value) {
    if (value == null) return {};

    if (value is Map<String, int>) {
      return value;
    } else if (value is Map) {
      final result = <String, int>{};
      value.forEach((key, val) {
        if (key is String) {
          result[key] = safeIntFromDynamic(val);
        }
      });
      return result;
    }

    return {};
  }

  // تحويل Map<String, dynamic> إلى Map<String, double>
  static Map<String, double> safeDoubleMapFromDynamic(dynamic value) {
    if (value == null) return {};

    if (value is Map<String, double>) {
      return value;
    } else if (value is Map) {
      final result = <String, double>{};
      value.forEach((key, val) {
        if (key is String) {
          result[key] = safeDoubleFromDynamic(val);
        }
      });
      return result;
    }

    return {};
  }

  // حساب النسبة المئوية
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0.0;
    return (value / total * 100).clamp(0.0, 100.0);
  }

  // حساب المتوسط
  static double calculateAverage(List<num> values) {
    if (values.isEmpty) return 0.0;

    final sum = values.fold<num>(0, (a, b) => a + b);
    return sum / values.length;
  }

  // حساب المتوسط المرجح
  static double calculateWeightedAverage(Map<double, double> valuesWithWeights) {
    if (valuesWithWeights.isEmpty) return 0.0;

    double totalWeightedValue = 0.0;
    double totalWeight = 0.0;

    valuesWithWeights.forEach((value, weight) {
      totalWeightedValue += value * weight;
      totalWeight += weight;
    });

    return totalWeight > 0 ? totalWeightedValue / totalWeight : 0.0;
  }

  // تطبيع القيم (0-100)
  static Map<String, double> normalizeValues(Map<String, double> values) {
    if (values.isEmpty) return {};

    final maxValue = values.values.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return values;

    final normalized = <String, double>{};
    values.forEach((key, value) {
      normalized[key] = (value / maxValue) * 100;
    });

    return normalized;
  }

  // حساب التشابه بين قائمتين
  static double calculateSimilarity(List<String> list1, List<String> list2) {
    if (list1.isEmpty && list2.isEmpty) return 1.0;
    if (list1.isEmpty || list2.isEmpty) return 0.0;

    final set1 = list1.toSet();
    final set2 = list2.toSet();

    final intersection = set1.intersection(set2);
    final union = set1.union(set2);

    return intersection.length / union.length;
  }

  // حساب المسافة الإقليدية
  static double calculateEuclideanDistance(List<double> vector1, List<double> vector2) {
    if (vector1.length != vector2.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double sum = 0.0;
    for (int i = 0; i < vector1.length; i++) {
      final diff = vector1[i] - vector2[i];
      sum += diff * diff;
    }

    return math.sqrt(sum);
  }

  // تقريب رقم لعدد معين من المنازل العشرية
  static double roundToDecimals(double value, int decimals) {
    final factor = math.pow(10, decimals);
    return (value * factor).round() / factor;
  }

  // تحويل الدرجات إلى تقدير
  static String scoreToGrade(double score) {
    if (score >= 90) return 'ممتاز';
    if (score >= 80) return 'جيد جداً';
    if (score >= 70) return 'جيد';
    if (score >= 60) return 'مقبول';
    return 'ضعيف';
  }

  // حساب مستوى الثقة
  static String confidenceLevel(double confidence) {
    if (confidence >= 0.8) return 'عالية';
    if (confidence >= 0.6) return 'متوسطة';
    return 'منخفضة';
  }
}

// استيراد مكتبة الرياضيات
