import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class ChatGroupNoticeApi {
  final Dio _dio = Http().dio;

  static final ChatGroupNoticeApi _instance = ChatGroupNoticeApi._internal();

  ChatGroupNoticeApi._internal();

  factory ChatGroupNoticeApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list(String chatGroupId) async {
    final response = await _dio
        .post('/v1/api/chat-group-notice/list', data: {'groupId': chatGroupId});
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String groupId, String noticeId) async {
    final response = await _dio.post('/v1/api/chat-group-notice/delete',
        data: {'groupId': groupId, 'noticeId': noticeId});
    return response.data;
  }

  Future<Map<String, dynamic>> create(String groupId, String content) async {
    final response = await _dio.post('/v1/api/chat-group-notice/create',
        data: {'groupId': groupId, 'content': content});
    return response.data;
  }

  Future<Map<String, dynamic>> update(
      String groupId, String groupNoticeId, String content) async {
    final response = await _dio.post('/v1/api/chat-group-notice/update', data: {
      'groupId': groupId,
      'noticeId': groupNoticeId,
      'noticeContent': content
    });
    return response.data;
  }
}
