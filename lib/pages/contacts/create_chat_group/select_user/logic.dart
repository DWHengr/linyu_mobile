// ignore_for_file: unnecessary_new, avoid_function_literals_in_foreach_calls
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/create_chat_group/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'index.dart';
import 'package:linyu_mobile/utils/extension.dart';

class ChatGroupSelectUserLogic extends Logic<ChatGroupSelectUserPage> {
  final _friendApi = FriendApi();

  final TextEditingController searchBoxController = new TextEditingController();

  final CreateChatGroupLogic createChatGroupLogic =
  GetInstance().find<CreateChatGroupLogic>();

  //所有的分组以及好友
  List<dynamic> friendList = [];

  List<dynamic> searchList = [];

  //建群聊时邀请的用户
  late List<dynamic> users = [];

  //选中的用户头像占用的宽度
  double _userTapWidth = 0;

  double get userTapWidth => _userTapWidth;

  set userTapWidth(double value) {
    _userTapWidth = value;
    update([const Key("chat_group_select_user")]);
  }

  int _chatGroupTextLength = 0;

  int get chatGroupTextLength => _chatGroupTextLength;

  set chatGroupTextLength(int value) {
    _chatGroupTextLength = value;
    update(['dialog']);
  }

  //初始化方法 当退回该页面的时候 使用controller.init()进行页面刷新
  void init() {
    _getFriendList();
    _getSelectUser();
  }

  //获取所有分组以及好友
  void _getFriendList() async {
    final result = await _friendApi.list();
    if (result['code'] == 0) {
      friendList = result['data'];
      update([const Key("chat_group_select_user")]);
    }
  }

  void _getSelectUser() {
    if (createChatGroupLogic.users.isNotEmpty) {
      users = createChatGroupLogic.users.copy();
    }
    userTapWidth = users.length * 40;
  }

  //添加到选中的用户中
  void addUsers(dynamic user) {
    user['isDelete'] = false;
    if (users.include(user as Map)) return;
    users.add(user as Map<String, dynamic>);
    userTapWidth += 40;
  }

  //删除选中的用户
  void subUsers(dynamic user) {
    if (users.isEmpty) return;
    if (user != null) {
      users.delete(user);
      userTapWidth -= 40;
      return;
    }
    if (users[users.length - 1]['isDelete']) {
      users.removeAt(users.length - 1);
      userTapWidth -= 40;
    } else {
      users[users.length - 1]['isDelete'] = true;
      update([const Key("chat_group_select_user")]);
    }
  }

  //当被选中时进行的操作
  void onSelect(dynamic user) {
    if (kDebugMode) {
      print('user:$user');
    }
    if (!users.include(user)) {
      addUsers(user);
      return;
    }
    subUsers(user);
  }

  //监听键盘 backspace键 事件
  void onBackKeyPress(KeyEvent event) {
    if (event is KeyUpEvent && searchBoxController.text.isEmpty) subUsers(null);
  }

  void onSubmitPress() {
    createChatGroupLogic.users = users;
    Get.back();
  }

  void onSearchFriend(String friendInfo) {
    if (friendInfo.trim() == '') {
      searchList = [];
      _getFriendList();
      return;
    }
    if (users.isNotEmpty) users[users.length - 1]['isDelete'] = false;
    _friendApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        friendList = [];
        searchList = res['data'];
        update([const Key("chat_group_select_user")]);
      }
    });
  }

  void onSelectGroup(dynamic group) {
    if (kDebugMode) {
      print('group:$group');
      print('friends:${group['friends']}');
    }
    // 检查是否存在'friends'字段并且是一个列表
    final List<dynamic>? friends =
    group['friends'] is List ? group['friends'] : null;
    if (friends == null || friends.isEmpty) {
      CustomFlutterToast.showErrorToast('该群组没有成员');
      return;
    }
    bool allIncluded = friends.every((friend) => users.include(friend));
    if (allIncluded) {
      // 如果所有好友都已经被选中，则取消选择
      friends.forEach((friend) => onSelect(friend));
      return;
    }
    // 否则，将所有未被选中的好友添加到选中列表中
    friends.forEach((friend) => addUsers(friend));
    // for (var friend in friends) {
    //   if (!users.include(friend)) {
    //     addUsers(friend);
    //   }
    //   // onSelect(friend);
    // }
  }

  Color checkBoxFillColor(dynamic group) {
    try {
      final List<dynamic>? friends = group['friends'] as List<dynamic>?;
      if (kDebugMode) {
        print('${group['name']} friends is null:${friends?.isEmpty}');
      }
      // 如果没有朋友列表，返回默认颜色
      if (friends == null || friends.isEmpty) return Colors.transparent;

      // if (friends == null) return Colors.transparent;
      // 使用任何函数检查是否有未包含的用户
      bool allIncluded = friends.every((friend) => users.include(friend));
      return allIncluded ? theme.primaryColor : Colors.transparent;
    } catch (e) {
      // 处理潜在的错误
      if (kDebugMode) {
        print('Error in checkBoxFillColor: $e');
      }
      return theme.searchBarColor; // 如果出错，返回默认颜色
    }
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
    createChatGroupLogic.update([const Key('create_chat_group')]);
    searchBoxController.dispose();
    users = [];
  }
}
