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

  Future<Map<String, dynamic>> list(int index, int num, String targetId) async {
    final response = await _dio.post('/v1/api/talk/list',
        data: {'index': index, 'num': num, 'targetId': targetId});
    return response.data;
  }

  Future<Map<String, dynamic>> details(String talkId) async {
    final response =
        await _dio.post('/v1/api/talk/details', data: {'talkId': talkId});
    return response.data;
  }

  Future<Map<String, dynamic>> uploadImg(FormData formData) async {
    final response =
        await _dio.post('/v1/api/talk/upload/img/form', data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> create(String text, List permission) async {
    final response = await _dio.post('/v1/api/talk/create',
        data: {'text': text, 'permission': permission});
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String talkId) async {
    final response =
        await _dio.post('/v1/api/talk/delete', data: {'talkId': talkId});
    return response.data;
  }
}
