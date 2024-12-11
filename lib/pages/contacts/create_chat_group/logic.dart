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
  void onRemarkChanged(String value) {
    nameLength = value.length;
  }

  //群公告输入框内容变化
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
