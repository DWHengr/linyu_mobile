import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/utils/String.dart';

class CreateChatGroupLogic extends GetxController {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController noticeController = TextEditingController();

  final ContactsLogic _contactsLogic = GetInstance().find<ContactsLogic>();

  final _chatGroupApi = ChatGroupApi();

  //群名称长度
  late int _nameLength = 0;
  int get nameLength => _nameLength;
  set nameLength(int value) {
    _nameLength = value;
    update([const Key('create_chat_group')]);
  }

  //群公告长度
  late int _noticeLength = 0;
  int get noticeLength => _noticeLength;
  set noticeLength(int value) {
    _noticeLength = value;
    update([const Key('create_chat_group')]);
  }

  //是否创建群聊（返回时判断是否刷新通讯列表页面）
  bool _isCreate = false;

  //建群聊时邀请的用户
  List<dynamic> users = [];

  //创建群聊
  void onCreateChatGroup() async {
    //群名称不能为空
    if (StringUtil.isNullOrEmpty(nameController.text)) {
      CustomFlutterToast.showErrorToast('请输入群名称~');
      return;
    }
    //当有用户被邀请时，创建群聊逻辑
    if (users.isNotEmpty && !StringUtil.isNullOrEmpty(nameController.text)) {
      _onCreateChatGroupWithUser();
      return;
    }
    //当没有用户被邀请时，创建群聊逻辑
    final response = await _chatGroupApi.create(nameController.text);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('创建群聊成功~');
      _isCreate = true;
      Get.back(result: true);
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
      _isCreate = false;
    }
  }

  //创建群聊逻辑
  void _onCreateChatGroupWithUser() async {
    // 群名称
    String chatGroupName = nameController.text;
    if (nameController.text.isEmpty) {
      chatGroupName = users
          .map((user) => user['remark'] ?? user['name'])
          .toList()
          .toString();
    }
    // 群成员
    List<Map<String, String>> groupMembers = [];
    for (var user in users) {
      groupMembers.add({
        'userId': user['friendId'],
        'name': user['remark'] ?? user['name'],
      });
    }
    // 创建群聊
    final result = await _chatGroupApi.createWithPerson(
        chatGroupName, noticeController.text, groupMembers);
    if (result['code'] == 0) {
      CustomFlutterToast.showSuccessToast('创建成功');
      _isCreate = true;
      Get.back();
    } else {
      CustomFlutterToast.showErrorToast(result['msg']);
      _isCreate = false;
    }
  }

  //群名称输入框内容变化
  void onRemarkChanged(String value) =>
      value.isNotEmpty ? nameLength = value.length : nameLength = 0;

  //群公告输入框内容变化
  void onNoticeTextChanged(String value) => value.isNotEmpty
      ? noticeLength = value.length.clamp(0, 100) // 使用clamp限制长度
      : noticeLength = 0; // 空值时设置长度为0

  //选择用户
  void onTapUserSelected() async {
    try {
      final result = await Get.toNamed('/chat_group_select_user', arguments: {
        'users': List.from(users), // 防止修改原数组
      });
      if (result != null) {
        // 只在结果不为空时更新
        users = result;
        update([const Key('create_chat_group')]);
      }
    } catch (e) {
      // 错误处理
      CustomFlutterToast.showErrorToast('无法选择用户，请重试。');
      if (kDebugMode) print('Error while selecting users: $e'); // 记录错误信息
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    if (_isCreate) _contactsLogic.init();
    super.onClose();
  }
}
