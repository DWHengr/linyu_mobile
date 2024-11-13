import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class QrApi {
  final Dio _dio = Http().dio;

  static final QrApi _instance = QrApi._internal();

  QrApi._internal();

  factory QrApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> code() async {
    final response =
        await _dio.get('/qr/code', queryParameters: {'action': 'mine'});
    return response.data;
  }

  Future<Map<String, dynamic>> status(String? key) async {
    final response = await _dio.get('/qr/code/status', data: {'key': key});
    return response.data;
  }
}
