import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends GetxController {
  final _userApi = UserApi();
  var unread = <String, int>{}.obs;
  var currentUserId = '';
  var currentUserAccount = '';
  late String? currentUserName;
  // late String? currentAvatarUrl =
  //     'http://192.168.101.4:9000/linyu/default-portrait.jpg';
  late String? currentAvatarUrl =
      'http://114.96.70.115:19000/linyu/default-portrait.jpg';
  late String? currentToken;

  Future<void> init() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-token');
      if (token == null) return;
      currentToken = token;
      currentUserId = prefs.getString('userId') ?? '';
      currentUserAccount = prefs.getString('account') ?? '';
      currentUserName = prefs.getString('username');
      currentAvatarUrl = prefs.getString('portrait') ??
          'http://114.96.70.115:19000/linyu/default-portrait.jpg';
      // 仅当用户 ID 不为空时才获取未读信息
      if (currentUserId.isNotEmpty) await onGetUserUnreadInfo();
    } catch (e) {
      // 增加错误处理
      if (kDebugMode) print('初始化失败: $e');
      // 根据需求可以添加其他处理逻辑，比如记录日志等
    }
  }

  Future<void> onGetUserUnreadInfo() async {
    try {
      final result = await _userApi.unread();
      if (result['code'] == 0) {
        unread.assignAll(Map<String, int>.from(result['data']));
        // 优化：仅在有未读消息时更新角标
        int chatCount = getUnreadCount('chat');
        int notifyCount = getUnreadCount('notify');
        if (chatCount > 0 || notifyCount > 0) {
          AppBadger.setCount(chatCount, notifyCount);
        }
      }
    } catch (e) {
      // 增加错误处理
      if (kDebugMode) print('获取未读信息失败: $e');
      // 这里可以根据需求添加其他处理逻辑，比如记录日志等
    }
  }

  int getUnreadCount(String type) {
    if (unread.value.containsKey(type)) return unread.value[type]!;
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
