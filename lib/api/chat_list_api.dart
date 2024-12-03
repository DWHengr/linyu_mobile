// lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class ChatListApi {
  final Dio _dio = Http().dio;

  static final ChatListApi _instance = ChatListApi._internal();

  ChatListApi._internal();

  Future<Map<String, dynamic>> list() async {
    final response = await _dio.get('/v1/api/chat-list/list');
    return response.data;
  }

  factory ChatListApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> top(String chatListId, bool isTop) async {
    final response = await _dio.post(
      '/v1/api/chat-list/top',
      data: {'chatListId': chatListId, 'isTop': isTop},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String chatListId) async {
    final response = await _dio.post(
      '/v1/api/chat-list/delete',
      data: {'chatListId': chatListId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> read(String targetId) async {
    final response = await _dio.get('/v1/api/chat-list/read/$targetId');
    return response.data;
  }

  Future<Map<String, dynamic>> detail(String targetId, String type) async {
    final response = await _dio.post('/v1/api/chat-list/detail',
        data: {'targetId': targetId, 'type': type});
    return response.data;
  }
}
