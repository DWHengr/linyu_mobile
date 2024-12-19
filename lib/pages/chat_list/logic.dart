import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/web_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListLogic extends GetxController {
  final _chatListApi = ChatListApi();
  final _friendApi = FriendApi();
  final FocusNode focusNode = new FocusNode(skipTraversal: true);
  late List<dynamic> topList = [];
  late List<dynamic> otherList = [];
  late List<dynamic> searchList = [];
  final _wsManager = WebSocketUtil();
  StreamSubscription? _subscription;
  late dynamic currentUserInfo = {};
  final TextEditingController searchBoxController = new TextEditingController();

  GlobalData get globalData => GetInstance().find<GlobalData>();

  void eventListen() {
    // 监听消息
    _subscription = _wsManager.eventStream.listen((event) {
      if (event['type'] == 'on-receive-msg') {
        onGetChatList();
      }
    });
  }

  void onGetChatList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currentUserInfo = {
        'name': prefs.getString('username'),
        'portrait': prefs.getString('portrait'),
        'account': prefs.getString('account'),
        'sex': prefs.getString('sex'),
      };

      final res = await _chatListApi.list();
      if (res['code'] == 0) {
        topList = res['data']['tops'];
        otherList = res['data']['others'];
        update([const Key("chat_list")]);
      } else {
        // 处理错误情况，比如提示用户
        if (kDebugMode) print('获取聊天列表失败: ${res['message']}');
      }
    } catch (e) {
      // 捕获和处理异常
      if (kDebugMode) print('发生错误: $e');
    }
  }

  void onTopStatus(String id, bool isTop) {
    _chatListApi.top(id, !isTop).then((res) {
      if (res['code'] == 0) {
        onGetChatList();
      }
    });
  }

  void onDeleteChatList(String id) {
    _chatListApi.delete(id).then((res) {
      if (res['code'] == 0) {
        onGetChatList();
      }
    });
  }

  void onSearchFriend(String friendInfo) {
    if (friendInfo.trim() == '') {
      searchList = [];
      update([const Key("chat_list")]);
      return;
    }
    _friendApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        searchList = res['data'];
        update([const Key("chat_list")]);
      }
    });
  }

  void onTapSearchFriend(dynamic friend) async {
    if (kDebugMode) print('tap search friend: $friend');
    try {
      final result =
      await _chatListApi.createChat(friend['friendId'], type: 'user');
      if (result['code'] == 0) {
        if (kDebugMode) print('创建聊天成功: ${result['data']}');
        await Get.toNamed('/chat_frame', arguments: {
          'chatInfo': result['data'],
        });
      } else {
        // 处理错误情况，提示用户
        if (kDebugMode) print('创建聊天失败: ${result['message']}');
      }
    } catch (e) {
      // 捕获和处理异常
      if (kDebugMode) print('发生错误: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    eventListen();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
