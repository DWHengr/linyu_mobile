import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class GroupApi {
  final Dio _dio = Http().dio;

  static final GroupApi _instance = GroupApi._internal();

  GroupApi._internal();

  factory GroupApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list() async {
    final response = await _dio.get('/v1/api/group/list');
    return response.data;
  }

  Future<Map<String, dynamic>> create(String groupName) async {
    final response =
        await _dio.post('/v1/api/group/create', data: {'groupName': groupName});
    return response.data;
  }
}
