import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../core/constants/app_constants.dart';

class Back4AppService {
  // Base CRUD operations
  static Future<List<T>> getAll<T extends ParseObject>(
      String className, {
        int limit = 20,
        int skip = 0,
        List<String>? include,
        String? orderBy,
        bool descending = false,
      }) async {
    try {
      final query = QueryBuilder<T>(ParseObject(className) as T);

      if (limit > 0) query.setLimit(limit);
      if (skip > 0) query.setAmountToSkip(skip);
      if (include != null && include.isNotEmpty) {
        query.includeObject(include);
      }
      if (orderBy != null) {
        descending ? query.orderByDescending(orderBy) : query.orderByAscending(orderBy);
      }

      final response = await query.query();
      if (response.success && response.results != null) {
        return response.results!.cast<T>();
      }
      throw Exception('Failed to fetch $className: ${response.error?.message}');
    } catch (e) {
      print('❌ Error in getAll $className: $e');
      rethrow;
    }
  }

  static Future<T?> getById<T extends ParseObject>(String className, String objectId) async {
    try {
      final query = QueryBuilder<T>(ParseObject(className) as T);
      query.whereEqualTo('objectId', objectId);

      final response = await query.query();
      if (response.success && response.results != null && response.results!.isNotEmpty) {
        return response.results!.first as T;
      }
      return null;
    } catch (e) {
      print('❌ Error in getById $className: $e');
      return null;
    }
  }

  static Future<String?> create(String className, Map<String, dynamic> data) async {
    try {
      final object = ParseObject(className);
      data.forEach((key, value) {
        object.set(key, value);
      });

      final response = await object.save();
      if (response.success) {
        return object.objectId;
      }
      throw Exception('Failed to create $className: ${response.error?.message}');
    } catch (e) {
      print('❌ Error in create $className: $e');
      rethrow;
    }
  }

  static Future<bool> update(String className, String objectId, Map<String, dynamic> data) async {
    try {
      final object = ParseObject(className)..objectId = objectId;
      data.forEach((key, value) {
        object.set(key, value);
      });

      final response = await object.save();
      return response.success;
    } catch (e) {
      print('❌ Error in update $className: $e');
      return false;
    }
  }

  static Future<bool> delete(String className, String objectId) async {
    try {
      final object = ParseObject(className)..objectId = objectId;
      final response = await object.delete();
      return response.success;
    } catch (e) {
      print('❌ Error in delete $className: $e');
      return false;
    }
  }

  // Query builders with conditions
  static QueryBuilder<T> buildQuery<T extends ParseObject>(String className) {
    return QueryBuilder<T>(ParseObject(className) as T);
  }

  static Future<List<T>> queryWithConditions<T extends ParseObject>(
      QueryBuilder<T> query,
      ) async {
    try {
      final response = await query.query();
      if (response.success && response.results != null) {
        return response.results!.cast<T>();
      }
      return [];
    } catch (e) {
      print('❌ Error in queryWithConditions: $e');
      return [];
    }
  }

  // Count records
  static Future<int> count(String className, {QueryBuilder? query}) async {
    try {
      final countQuery = query ?? QueryBuilder(ParseObject(className));
      final response = await countQuery.count();
      if (response.success) {
        return response.count;
      }
      return 0;
    } catch (e) {
      print('❌ Error in count $className: $e');
      return 0;
    }
  }
}