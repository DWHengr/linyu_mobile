import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get_instance/src/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/web_socket.dart';

class ChatListLogic extends GetxController {
  final _chatListApi = ChatListApi();
  final _friendApi = FriendApi();
  late List<dynamic> topList = [];
  late List<dynamic> otherList = [];
  late List<dynamic> searchList = [];
  final _wsManager = WebSocketUtil();
  StreamSubscription? _subscription;

  GlobalData get globalData => GetInstance().find<GlobalData>();

  @override
  void onInit() {
    eventListen();
  }

  void eventListen() {
    // 监听消息
    _subscription = _wsManager.eventStream.listen((event) {
      if (event['type'] == 'on-receive-msg') {
        onGetChatList();
      }
    });
  }

  void onGetChatList() {
    _chatListApi.list().then((res) {
      if (res['code'] == 0) {
        topList = res['data']['tops'];
        otherList = res['data']['others'];
        update([const Key("chat_list")]);
      }
    });
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
    if (friendInfo == null || friendInfo.trim() == '') {
      searchList = [];
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

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
