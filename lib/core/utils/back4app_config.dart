// lib/core/utils/back4app_config.dart

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Back4AppConfig {
  static const String _applicationId = 'sTrN70UOF0VMB8PdcfFaSTeCTKLU7cVBA0bckGNr';
  static const String _clientKey = 'uiAlhYsyiLwfjFnV911HigzIfMYUzp4YyEj0PWEr';
  static const String _serverUrl = 'https://parseapi.back4app.com';

  static Future<bool> initialize() async {
    try {
      await Parse().initialize(
        _applicationId,
        _serverUrl,
        clientKey: _clientKey,
        autoSendSessionId: true,
        coreStore: await CoreStoreSharedPreferences.getInstance(),
      );

      // تفعيل debugging في وضع التطوير
      // Parse().enableLogging(true);

      print('✅ تم تهيئة Back4App بنجاح');
      return true;
    } catch (e) {
      print('❌ خطأ في تهيئة Back4App: $e');
      return false;
    }
  }

  // دالة للتحقق من الاتصال
  static Future<bool> checkConnection() async {
    try {
      final healthCheck = ParseCloudFunction('hello');
      final response = await healthCheck.execute();
      return response.success;
    } catch (e) {
      print('❌ خطأ في التحقق من الاتصال: $e');
      return false;
    }
  }

  // إعدادات الاستعلامات
  static QueryBuilder<T> getQuery<T extends ParseObject>(String className) {
    return QueryBuilder<T>(ParseObject(className) as T);
  }

  // إعدادات التحميل مع التحكم في عدد النتائج
  static QueryBuilder<T> getPaginatedQuery<T extends ParseObject>(
      String className, {
        int limit = 20,
        int skip = 0,
      }) {
    final query = QueryBuilder<T>(ParseObject(className) as T);
    query.setLimit(limit);
    query.setAmountToSkip(skip);
    return query;
  }
}