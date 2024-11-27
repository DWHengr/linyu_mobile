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

  Future<Map<String, dynamic>> update(
      String chatGroupId, String key, dynamic value) async {
    final response = await _dio.post('/v1/api/chat-group/update',
        data: {'groupId': chatGroupId, 'updateKey': key, 'updateValue': value});
    return response.data;
  }

  Future<Map<String, dynamic>> updateName(
      String chatGroupId, String name) async {
    final response = await _dio.post('/v1/api/chat-group/update/name', data: {
      'groupId': chatGroupId,
      'name': name,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> kickChatGroup(
      String groupId, String userId) async {
    final response = await _dio.post('/v1/api/chat-group/kick', data: {
      'groupId': groupId,
      'userId': userId,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> inviteMember(
      String groupId, List<dynamic> ids) async {
    final response = await _dio.post('/v1/api/chat-group/invite', data: {
      'groupId': groupId,
      'userIds': ids,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> transferChatGroup(
      String groupId, String userId) async {
    final response = await _dio.post('/v1/api/chat-group/transfer', data: {
      'groupId': groupId,
      'userId': userId,
    });
    return response.data;
  }
}
