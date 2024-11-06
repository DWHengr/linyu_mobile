// lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:linyu_mobile/api/http.dart';

class UserApi {
  final Dio _dio = Http().dio;

  Future<Map<String, dynamic>> login(String account, String password) async {
    try {
      final response = await _dio.post(
        '/v1/api/login',
        data: {'account': account, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Get profile error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> publicKey() async {
    final response = await _dio.get('/v1/api/login/public-key');
    return response.data;
  }
}
