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

  late int _nameLength = 0;

  int get nameLength => _nameLength;

  set nameLength(int value) {
    _nameLength = value;
    update([const Key('create_chat_group')]);
  }

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

  void onCreateChatGroup() async {
    if (users.isNotEmpty) {
      _onCreateChatGroupWithUser();
      return;
    }
    if (StringUtil.isNullOrEmpty(nameController.text)) {
      CustomFlutterToast.showErrorToast('请输入群名称~');
      return;
    }
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

  //创建群聊
  void _onCreateChatGroupWithUser() async {
    String chatGroupName = nameController.text;
    if (nameController.text.isEmpty) {
      chatGroupName = users
          .map((user) => user['remark'] ?? user['name'])
          .toList()
          .toString();
    }
    List<Map<String, String>> groupMembers = [];
    for (var user in users) {
      groupMembers.add({
        'userId': user['friendId'],
        'name': user['remark'] ?? user['name'],
      });
    }
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

  void onRemarkChanged(String value) {
    nameLength = value.length;
  }

  void onNoticeTextChanged(String value) {
    if (noticeLength >= 100) {
      noticeLength = 100;
      return;
    }
    noticeLength = value.length;
  }

  @override
  void onClose() {
    nameController.dispose();
    if (_isCreate) _contactsLogic.init();
    super.onClose();
  }
}
