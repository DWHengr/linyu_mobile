// lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:linyu_mobile/api/Http.dart';

class FriendApi {
  final Dio _dio = Http().dio;

  static final FriendApi _instance = FriendApi._internal();

  FriendApi._internal();

  factory FriendApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> list() async {
    final response = await _dio.get('/v1/api/friend/list');
    return response.data;
  }

  Future<Map<String, dynamic>> search(String friendInfo) async {
    final response = await _dio.post(
      '/v1/api/friend/search',
      data: {'friendInfo': friendInfo},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> addFriendByQr(String qrCode) async {
    final response = await _dio.post(
      '/v1/api/friend/add/qr',
      data: {'qrCode': qrCode},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> details(String friendId) async {
    final response = await _dio.get(
      '/v1/api/friend/details/$friendId',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> setRemark(String friendId, String remark) async {
    final response = await _dio.post(
      '/v1/api/friend/set/remark',
      data: {
        'friendId': friendId,
        'remark': remark,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> setGroup(String friendId, String groupId) async {
    final response = await _dio.post(
      '/v1/api/friend/set/group',
      data: {
        'friendId': friendId,
        'groupId': groupId,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> careFor(String friendId) async {
    final response = await _dio.post(
      '/v1/api/friend/carefor',
      data: {
        'friendId': friendId,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> unCareFor(String friendId) async {
    final response = await _dio.post(
      '/v1/api/friend/uncarefor',
      data: {
        'friendId': friendId,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> delete(String friendId) async {
    final response = await _dio.post(
      '/v1/api/friend/delete',
      data: {
        'friendId': friendId,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> agree(String notifyId) async {
    final response = await _dio.post(
      '/v1/api/friend/agree',
      data: {
        'notifyId': notifyId,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> isFriend(String friendId) async {
    final response = await _dio.get(
      '/v1/api/friend/is/friend',
      queryParameters: {'targetId': friendId},
    );
    return response.data;
  }
}
