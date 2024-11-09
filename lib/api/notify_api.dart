import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class NotifyApi {
  final Dio _dio = Http().dio;

  static final NotifyApi _instance = NotifyApi._internal();

  NotifyApi._internal();

  factory NotifyApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> friendList() async {
    final response = await _dio.get('/v1/api/notify/friend/list');
    return response.data;
  }
}
