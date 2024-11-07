// lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class TalkApi {
  final Dio _dio = Http().dio;

  static final TalkApi _instance = TalkApi._internal();

  TalkApi._internal();

  factory TalkApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list(int index, int num) async {
    final response = await _dio
        .post('/v1/api/talk/list', data: {'index': index, 'num': num});
    return response.data;
  }
}
