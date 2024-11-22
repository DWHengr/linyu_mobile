import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class TalkLikeApi {
  final Dio _dio = Http().dio;

  static final TalkLikeApi _instance = TalkLikeApi._internal();

  TalkLikeApi._internal();

  factory TalkLikeApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list(String talkId) async {
    final response =
        await _dio.post('/v1/api/talk-like/list', data: {'talkId': talkId});
    return response.data;
  }

  Future<Map<String, dynamic>> create(String talkId) async {
    final response =
        await _dio.post('/v1/api/talk-like/create', data: {'talkId': talkId});
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String talkId) async {
    final response =
        await _dio.post('/v1/api/talk-like/delete', data: {'talkId': talkId});
    return response.data;
  }
}
