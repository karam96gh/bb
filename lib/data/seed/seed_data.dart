// lib/data/seed/seed_data.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'products_seed.dart';
import 'categories_seed.dart';
import 'survey_questions_seed.dart';

class SeedData {
  static Future<void> seedAllData() async {
    try {
      print('🌱 بدء إضافة البيانات الأساسية...');

      // تحقق من وجود البيانات أولاً
      if (await _dataExists()) {
        print('ℹ️ البيانات موجودة بالفعل، تخطي عملية الإضافة');
        return;
      }

      // إضافة الأصناف أولاً
      await _seedCategories();
      print('✅ تم إضافة الأصناف بنجاح (${CategoriesSeedData.getCategories().length} صنف)');

      // انتظار قليل للتأكد من إضافة الأصناف
      await Future.delayed(Duration(seconds: 1));

      // إضافة المنتجات
      await _seedProducts();
      print('✅ تم إضافة المنتجات بنجاح (${ProductsSeedData.getProducts().length} منتج)');

      // إضافة أسئلة الاستطلاع
      await _seedSurveyQuestions();
      print('✅ تم إضافة أسئلة الاستطلاع بنجاح (${SurveyQuestionsSeedData.getQuestions().length} سؤال)');

      print('🎉 تم إضافة جميع البيانات الأساسية بنجاح!');

    } catch (e) {
      print('❌ خطأ في إضافة البيانات: $e');
      rethrow;
    }
  }

  // التحقق من وجود البيانات
  static Future<bool> _dataExists() async {
    try {
      final categoriesQuery = QueryBuilder<ParseObject>(ParseObject('Categories'));
      final categoriesResponse = await categoriesQuery.query();

      final productsQuery = QueryBuilder<ParseObject>(ParseObject('Products'));
      final productsResponse = await productsQuery.query();

      final questionsQuery = QueryBuilder<ParseObject>(ParseObject('Survey_Questions'));
      final questionsResponse = await questionsQuery.query();

      return (categoriesResponse.success && (categoriesResponse.results?.length ?? 0) > 0) ||
          (productsResponse.success && (productsResponse.results?.length ?? 0) > 0) ||
          (questionsResponse.success && (questionsResponse.results?.length ?? 0) > 0);
    } catch (e) {
      print('❌ خطأ في التحقق من وجود البيانات: $e');
      return false;
    }
  }

  static Future<void> _seedCategories() async {
    final categories = CategoriesSeedData.getCategories();

    for (var categoryData in categories) {
      try {
        final category = ParseObject('Categories');

        categoryData.forEach((key, value) {
          category.set(key, value);
        });

        final response = await category.save();
        if (!response.success) {
          print('⚠️ فشل في إضافة الصنف: ${categoryData['arabicName']} - ${response.error?.message}');
        }
      } catch (e) {
        print('❌ خطأ في إضافة الصنف ${categoryData['arabicName']}: $e');
      }
    }
  }

  static Future<void> _seedProducts() async {
    // الحصول على الأصناف المضافة
    final categoriesQuery = QueryBuilder<ParseObject>(ParseObject('Categories'));
    final categoriesResponse = await categoriesQuery.query();

    if (!categoriesResponse.success || categoriesResponse.results == null) {
      throw Exception('لم يتم العثور على الأصناف');
    }

    // إنشاء خريطة للأصناف
    final categoriesMap = <String, String>{};
    for (var category in categoriesResponse.results!) {
      final categoryName = category.get<String>('name');
      final categoryId = category.get<String>('objectId');
      if (categoryName != null && categoryId != null) {
        categoriesMap[categoryName.toLowerCase()] = categoryId;
      }
    }

    final products = ProductsSeedData.getProducts();

    for (var productData in products) {
      try {
        final product = ParseObject('Products');

        // ربط المنتج بالصنف المناسب
        final categoryName = productData['category'] as String;
        final categoryId = categoriesMap[categoryName];

        if (categoryId != null) {
          // إزالة category من البيانات وإضافته كـ Pointer
          final productDataCopy = Map<String, dynamic>.from(productData);
          productDataCopy.remove('category');

          productDataCopy.forEach((key, value) {
            product.set(key, value);
          });

          // إضافة الـ Pointer للصنف
          product.set('category', ParseObject('Categories')..objectId = categoryId);

          final response = await product.save();
          if (!response.success) {
            print('⚠️ فشل في إضافة المنتج: ${productData['arabicName']} - ${response.error?.message}');
          }
        } else {
          print('⚠️ لم يتم العثور على الصنف: $categoryName للمنتج: ${productData['arabicName']}');
        }
      } catch (e) {
        print('❌ خطأ في إضافة المنتج ${productData['arabicName']}: $e');
      }
    }
  }

  static Future<void> _seedSurveyQuestions() async {
    final questions = SurveyQuestionsSeedData.getQuestions();

    for (var questionData in questions) {
      try {
        final question = ParseObject('Survey_Questions');

        questionData.forEach((key, value) {
          question.set(key, value);
        });

        final response = await question.save();
        if (!response.success) {
          print('⚠️ فشل في إضافة السؤال رقم: ${questionData['questionNumber']} - ${response.error?.message}');
        }
      } catch (e) {
        print('❌ خطأ في إضافة السؤال رقم ${questionData['questionNumber']}: $e');
      }
    }
  }

  // دالة لحذف جميع البيانات (للاختبار والتطوير)
  static Future<void> clearAllData() async {
    try {
      print('🗑️ بدء حذف جميع البيانات...');

      // حذف البيانات بالترتيب الصحيح (العكسي)
      await _clearTable('Orders');
      await _clearTable('Cart');
      await _clearTable('Surveys');
      await _clearTable('Product_Reviews');
      await _clearTable('Products');
      await _clearTable('Survey_Questions');
      await _clearTable('Categories');

      print('✅ تم حذف جميع البيانات بنجاح');

    } catch (e) {
      print('❌ خطأ في حذف البيانات: $e');
      rethrow;
    }
  }

  static Future<void> _clearTable(String tableName) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject(tableName));
      final response = await query.query();

      if (response.success && response.results != null) {
        for (var object in response.results!) {
          await object.delete();
        }
        print('✅ تم حذف جدول $tableName (${response.results!.length} عنصر)');
      } else {
        print('ℹ️ جدول $tableName فارغ أو غير موجود');
      }
    } catch (e) {
      print('❌ خطأ في حذف جدول $tableName: $e');
    }
  }

  // دالة لإعادة تعبئة البيانات
  static Future<void> resetAndSeedData() async {
    try {
      print('🔄 بدء إعادة تعبئة البيانات...');
      await clearAllData();
      await Future.delayed(Duration(seconds: 2)); // انتظار لضمان اكتمال الحذف
      await seedAllData();
      print('🎉 تم إعادة تعبئة البيانات بنجاح!');
    } catch (e) {
      print('❌ خطأ في إعادة تعبئة البيانات: $e');
      rethrow;
    }
  }
}