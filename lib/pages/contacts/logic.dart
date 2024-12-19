import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/web_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsLogic extends GetxController {
  final _friendApi = new FriendApi();
  final _chatGroupApi = new ChatGroupApi();
  final _notifyApi = new NotifyApi();
  final _chatListApi = new ChatListApi();
  final GlobalData _globalData = GetInstance().find<GlobalData>();
  List<String> tabs = ['我的群聊', '我的好友', '好友通知'];
  int selectedIndex = 1;
  String currentUserId = '';
  List<dynamic> friendList = [];
  List<dynamic> chatGroupList = [];
  List<dynamic> notifyFriendList = [];
  late dynamic currentUserInfo = {};
  List<dynamic> searchList = [];
  final TextEditingController searchBoxController = new TextEditingController();
  final _wsManager = new WebSocketUtil();
  StreamSubscription? _subscription;

  GlobalData get globalData => GetInstance().find<GlobalData>();

  // 监听消息
  void eventListen() => _subscription = _wsManager.eventStream.listen(
        (event) {
      if (event['type'] == 'on-receive-notify') init();
    },
    onError: (error) {
      CustomFlutterToast.showErrorToast("监听事件流时发生错误: $error");
    },
    onDone: () {
      if (kDebugMode) print("事件流监听完成");
    },
    cancelOnError: true, // 如果发生错误，取消订阅
  );

  void onFriendList() async {
    try {
      final res = await _friendApi.list();
      if (res['code'] == 0) {
        friendList = res['data'];
        update([const Key("contacts")]);
      } else {
        // 处理非成功状态
        CustomFlutterToast.showErrorToast("获取好友列表失败: ${res['msg']}");
      }
    } catch (e) {
      // 捕获异常并处理
      CustomFlutterToast.showErrorToast("网络错误: $e");
    }
  }

  void onChatGroupList() {
    try {
      globalData.onGetUserUnreadInfo();
      _chatGroupApi.list().then((res) {
        if (res['code'] == 0) {
          chatGroupList = res['data'];
          update([const Key("contacts")]);
        } else {
          // 处理非成功状态
          CustomFlutterToast.showErrorToast("获取群聊列表失败: ${res['msg']}");
        }
      }).catchError((e) {
        // 捕获异常并处理
        CustomFlutterToast.showErrorToast("获取群聊列表时发生网络错误: $e");
      });
    } catch (e) {
      // 处理其他可能的异常
      CustomFlutterToast.showErrorToast("处理群聊列表时发生错误: $e");
    }
  }

  void onNotifyFriendList() {
    _notifyApi.friendList().then((res) {
      if (res['code'] == 0) {
        notifyFriendList = res['data'];
        update([const Key("contacts")]);
      } else {
        CustomFlutterToast.showErrorToast("获取好友通知列表失败: ${res['msg']}");
      }
    }).catchError((e) {
      CustomFlutterToast.showErrorToast("获取好友通知列表时发生网络错误: $e");
    });
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserInfo['name'] = prefs.getString('username');
    currentUserInfo['portrait'] = prefs.getString('portrait');
    currentUserInfo['account'] = prefs.getString('account');
    currentUserInfo['sex'] = prefs.getString('sex');
    currentUserId = prefs.getString('userId') ?? '';
    onNotifyFriendList();
    onChatGroupList();
    onFriendList();
  }

  void onReadNotify() async {
    try {
      await _notifyApi.read('friend');
      await _globalData.onGetUserUnreadInfo();
    } catch (e) {
      CustomFlutterToast.showErrorToast("读取通知失败: $e");
    }
  }

  void handlerTabTapped(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      update([const Key("contacts")]);
      if (index == 2) {
        try {
          onReadNotify();
        } catch (e) {
          CustomFlutterToast.showErrorToast("读取通知失败: $e");
        }
      }
    }
  }

  void handlerFriendTapped(dynamic friend) {
    try {
      if (friend == null || !friend.containsKey('friendId')) {
        CustomFlutterToast.showErrorToast("好友信息无效");
        return;
      }
      Get.toNamed('/friend_info', arguments: {'friendId': friend['friendId']});
    } catch (e) {
      CustomFlutterToast.showErrorToast("导航到好友信息页面失败: $e");
    }
  }

  //同意添加好友
  void handlerAgreeFriend(dynamic notify) async {
    try {
      onReadNotify();
      final result = await _friendApi.agree(notify['id'], notify['fromId']);
      if (result['code'] == 0) {
        init();
        CustomFlutterToast.showSuccessToast("同意好友请求成功");
      } else {
        CustomFlutterToast.showErrorToast("同意好友请求失败: ${result['msg']}");
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast("网络错误: $e");
    }
  }

  //拒绝添加好友
  void handlerRejectFriend(dynamic notify) async {
    onReadNotify();
    try {
      final result = await _friendApi.reject(notify['fromId']);
      if (result['code'] == 0) {
        init();
        CustomFlutterToast.showSuccessToast("操作成功");
      } else {
        CustomFlutterToast.showErrorToast("拒绝好友请求失败: ${result['msg']}");
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast("网络错误: $e");
    }
  }

  //长按分组进入分组设置页面
  void onLongPressGroup() {
    try {
      Get.toNamed("/set_group", arguments: {'groupName': '0', 'friendId': '0'});
    } catch (e) {
      CustomFlutterToast.showErrorToast("导航到群组设置页面失败: $e");
    }
  }

  //设置特别关心
  void onSetConcernFriend(dynamic friend) async {
    try {
      Map<String, dynamic> response;
      if (friend['isConcern']) {
        response = await _friendApi.unCareFor(friend['friendId']);
      } else {
        response = await _friendApi.careFor(friend['friendId']);
      }

      _setResult(response);
      Get.back();
      init();
    } catch (e) {
      CustomFlutterToast.showErrorToast("操作失败: $e");
    }
  }

  //特别关心结果
  void _setResult(Map<String, dynamic> response) {
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('设置成功~');
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  void onSearchFriend(String friendInfo) {
    friendInfo = friendInfo.trim();
    if (friendInfo.isEmpty) {
      searchList.clear();
      init();
      return;
    }

    _friendApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        friendList.clear();
        searchList = res['data'];
        update([const Key("contacts")]);
      } else {
        CustomFlutterToast.showErrorToast("搜索好友失败: ${res['msg']}");
      }
    }).catchError((e) {
      CustomFlutterToast.showErrorToast("网络错误: $e");
    });
  }

  String getNotifyContentTip(String status, bool isFromCurrentUser) {
    if (!isFromCurrentUser) return "请求加你为好友";
    switch (status) {
      case "wait":
        return "正在验证请求";
      case "reject":
        return "已拒绝申请请求";
      case "agree":
        return "已同意申请请求";
      default:
        CustomFlutterToast.showErrorToast("未知的通知状态: $status");
        return "";
    }
  }

  void onToSendGroupMsg(id) =>
      _chatListApi.createChat(id, type: 'group').then((res) {
        if (res['code'] == 0) {
          Get.toNamed('/chat_frame', arguments: {
            'chatInfo': res['data'],
          });
        }
      });

  void toChatGroupInfo(dynamic group) {
    if (group == null || !group.containsKey('id')) {
      CustomFlutterToast.showErrorToast("群组信息无效");
      return;
    }
    try {
      Get.toNamed('/chat_group_info', arguments: {'chatGroupId': group['id']});
    } catch (e) {
      CustomFlutterToast.showErrorToast("导航到群组信息页面失败: $e");
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
