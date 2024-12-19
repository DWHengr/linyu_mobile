import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' show PrettyDioLogger;
import 'package:shared_preferences/shared_preferences.dart';

class Http {
  static final Http _instance = Http._internal();

  factory Http() => _instance;

  late Dio dio;

  Http._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.17:9200',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));
    // 添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // 从本地存储获取token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-token');
      if (token != null) {
        options.headers['x-token'] = token;
      }
      return handler.next(options);
    }, onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // 处理token过期
      }
      return handler.next(error);
    }));
    if (!kReleaseMode)
      dio.interceptors.add(PrettyDioLogger(
        // requestHeader: true,
        // requestBody: true,
        // responseHeader: true,
        responseBody: true,
      ));
  }
}
