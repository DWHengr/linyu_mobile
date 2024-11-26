import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class ChatGroupApi {
  final Dio _dio = Http().dio;

  static final ChatGroupApi _instance = ChatGroupApi._internal();

  ChatGroupApi._internal();

  factory ChatGroupApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list() async {
    final response = await _dio.get('/v1/api/chat-group/list');
    return response.data;
  }

  Future<Map<String, dynamic>> details(String chatGroupId) async {
    final response = await _dio
        .post('/v1/api/chat-group/details', data: {'chatGroupId': chatGroupId});
    return response.data;
  }

  Future<Map<String, dynamic>> upload(FormData formData) async {
    final response = await _dio.post(
      '/v1/api/chat-group/upload/portrait/form',
      data: formData,
    );
    return response.data;
  }
}
