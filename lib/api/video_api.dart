import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class VideoApi {
  final Dio _dio = Http().dio;

  static final VideoApi _instance = VideoApi._internal();

  VideoApi._internal();

  factory VideoApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> offer(String userId, dynamic desc) async {
    final response = await _dio.post('/v1/api/video/offer', data: {
      'userId': userId,
      'desc': desc,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> answer(String userId, dynamic desc) async {
    final response = await _dio.post(
      '/v1/api/video/answer',
      data: {'userId': userId, 'desc': desc},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> candidate(
      String userId, dynamic candidate) async {
    final response = await _dio.post(
      '/v1/api/video/candidate',
      data: {'userId': userId, 'candidate': candidate},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> hangup(String userId) async {
    final response = await _dio.post(
      '/v1/api/video/hangup',
      data: {'userId': userId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> invite(String userId, bool isOnlyAudio) async {
    final response = await _dio.post(
      '/v1/api/video/invite',
      data: {'userId': userId, 'isOnlyAudio': isOnlyAudio},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> accept(String userId) async {
    final response = await _dio.post(
      '/v1/api/video/accept',
      data: {'userId': userId},
    );
    return response.data;
  }
}
