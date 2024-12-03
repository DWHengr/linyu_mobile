import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/web_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsLogic extends GetxController {
  final _friendApi = FriendApi();
  final _chatGroupApi = ChatGroupApi();
  final _notifyApi = NotifyApi(); //主题配置
  final GlobalData _globalData = GetInstance().find<GlobalData>();
  List<String> tabs = ['我的群聊', '我的好友', '好友通知'];
  int selectedIndex = 1;
  String currentUserId = '';
  List<dynamic> friendList = [];
  List<dynamic> chatGroupList = [];
  List<dynamic> notifyFriendList = [];

  final _wsManager = WebSocketUtil();
  StreamSubscription? _subscription;

  GlobalData get globalData => GetInstance().find<GlobalData>();

  @override
  void onInit() {
    super.onInit();
    eventListen();
  }

  void eventListen() {
    // 监听消息
    _subscription = _wsManager.eventStream.listen((event) {
      if (event['type'] == 'on-receive-notify') {
        init();
      }
    });
  }

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      currentUserId = prefs.getString('userId') ?? '';
      update([const Key("contacts")]);
    });
    onNotifyFriendList();
    onChatGroupList();
    onFriendList();
  }

  void onFriendList() {
    _friendApi.list().then((res) {
      if (res['code'] == 0) {
        friendList = res['data'];
        update([const Key("contacts")]);
      }
    });
  }

  void onChatGroupList() {
    globalData.onGetUserUnreadInfo();
    _chatGroupApi.list().then((res) {
      if (res['code'] == 0) {
        chatGroupList = res['data'];
        update([const Key("contacts")]);
      }
    });
  }

  void onNotifyFriendList() {
    _notifyApi.friendList().then((res) {
      if (res['code'] == 0) {
        notifyFriendList = res['data'];
        update([const Key("contacts")]);
      }
    });
  }

  void onReadNotify() async {
    await _notifyApi.read('friend');
    await _globalData.onGetUserUnreadInfo();
  }

  void handlerTabTapped(int index) {
    selectedIndex = index;
    update([const Key("contacts")]);
    if (index == 2) {
      onReadNotify();
    }
  }

  void handlerFriendTapped(dynamic friend) {
    Get.toNamed('/friend_info', arguments: {'friendId': friend['friendId']});
  }

  //同意添加好友
  void handlerAgreeFriend(dynamic notify) async {
    onReadNotify();
    final result = await _friendApi.agree(notify['id'], notify['fromId']);
    if (result['code'] == 0) {
      init();
      CustomFlutterToast.showSuccessToast("同意好友请求成功");
    } else {
      CustomFlutterToast.showErrorToast("同意好友请求失败");
    }
  }

  //拒绝添加好友
  void handlerRejectFriend(dynamic notify) async {
    onReadNotify();
    final result = await _friendApi.reject(notify['fromId']);
    if (result['code'] == 0) {
      init();
      CustomFlutterToast.showSuccessToast("操作成功");
    } else {
      CustomFlutterToast.showErrorToast("网络错误");
    }
  }

  //长按分组进入分组设置页面
  void onLongPressGroup() {
    Get.toNamed("/set_group", arguments: {'groupName': '0', 'friendId': '0'});
  }

  //设置特别关心
  void onSetConcernFriend(dynamic friend) async {
    if (friend['isConcern']) {
      final response = await _friendApi.unCareFor(friend['friendId']);
      setResult(response);
    } else {
      final response = await _friendApi.careFor(friend['friendId']);
      setResult(response);
    }
    Get.back();
    init();
  }

  //特别关心结果
  void setResult(Map<String, dynamic> response) {
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('设置成功~');
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
