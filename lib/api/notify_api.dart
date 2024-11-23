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

  Future<Map<String, dynamic>> friendApply(
      String userId, String content) async {
    final response = await _dio.post(
      '/v1/api/notify/friend/apply',
      data: {'userId': userId, 'content': content},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> read(type) async {
    final response =
        await _dio.post('/v1/api/notify/read', data: {'notifyType': type});
    return response.data;
  }
}
