import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class ChatGroupMemberApi {
  final Dio _dio = Http().dio;

  static final ChatGroupMemberApi _instance = ChatGroupMemberApi._internal();

  ChatGroupMemberApi._internal();

  factory ChatGroupMemberApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list(String chatGroupId) async {
    final response = await _dio.get('/v1/api/chat-group-member/list',
        data: {'chatGroupId': chatGroupId});
    return response.data;
  }

  Future<Map<String, dynamic>> listPage(String chatGroupId) async {
    final response = await _dio.post('/v1/api/chat-group-member/list/page',
        data: {'chatGroupId': chatGroupId});
    return response.data;
  }
}
