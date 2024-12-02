import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'
    show Get, GetInstance, GetNavigation, GetxController;
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/chat_group_member.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;

class ChatGroupInformationLogic extends GetxController {
  final ContactsLogic _contactsLogic = GetInstance().find<ContactsLogic>();
  final _chatGroupApi = ChatGroupApi();
  final _chatGroupMemberApi = ChatGroupMemberApi();
  late String? _currentUserId = '';
  late bool isOwner = false;
  late dynamic chatGroupDetails = {
    'id': '',
    'userId': '',
    'ownerUserId': '',
    'portrait': '',
    'name': '',
    'notice': {
      "id": "",
      "chatGroupId": "",
      "userId": "",
      "noticeContent": "",
      "createTime": "",
      "updateTime": ""
    },
    'memberNum': '',
    'groupName': '',
    'groupRemark': '',
  };
  late List<dynamic> chatGroupMembers = [];
  final String chatGroupId = Get.arguments['chatGroupId'];
  double _groupMemberWidth = 0;

  double get groupMemberWidth => _groupMemberWidth;

  set groupMemberWidth(double value) {
    _groupMemberWidth = value;
    update([const Key('chat_group_info')]);
  }

  @override
  void onInit() {
    onGetGroupChatDetails();
    onGetGroupChatMembers();
    super.onInit();
  }

  Future<void> onGetGroupChatDetails() async {
    await _chatGroupApi.details(chatGroupId).then((res) async {
      if (res['code'] == 0) {
        chatGroupDetails = res['data'];
        final prefs = await SharedPreferences.getInstance();
        _currentUserId = prefs.getString('userId');
        if (_currentUserId == chatGroupDetails['ownerUserId']) {
          isOwner = true;
        } else {
          isOwner = false;
        }
        update([const Key('chat_group_info')]);
      }
    });
  }

  void onGetGroupChatMembers() async {
    _chatGroupMemberApi.listPage(chatGroupId).then((res) {
      if (res['code'] == 0) {
        chatGroupMembers = res['data'];
        groupMemberWidth = chatGroupMembers.length * 40 + 10;
        if (groupMemberWidth >= 190) {
          groupMemberWidth = 190;
        }
        // update([const Key('chat_group_info')]);
      }
    });
  }

  Future<void> _onUpdateChatGroupPortrait(File picture) async {
    Map<String, dynamic> map = {};
    final file = await MultipartFile.fromFile(picture.path,
        filename: picture.path.split('/').last);
    map['type'] = 'image/jpeg';
    map['name'] = picture.path.split('/').last;
    map['size'] = picture.lengthSync();
    map["file"] = file;
    map['groupId'] = chatGroupId;
    FormData formData = FormData.fromMap(map);
    final result = await _chatGroupApi.upload(formData);
    if (result['code'] == 0) {
      CustomFlutterToast.showSuccessToast('头像修改成功');
      chatGroupDetails['portrait'] = result['data'];
      update([const Key("chat_group_info")]);
    } else {
      CustomFlutterToast.showErrorToast(result['msg']);
    }
  }

  void selectPortrait() {
    Get.toNamed('/image_viewer_update', arguments: {
      'imageUrl': chatGroupDetails['portrait'],
      'onConfirm': _onUpdateChatGroupPortrait,
      'isUpdate': isOwner
    });
  }

  void setGroupName() async {
    var result = await Get.toNamed('/set_group_name', arguments: {
      'chatGroupId': chatGroupId,
      'name': chatGroupDetails['name']
    });
    if (result != null) {
      chatGroupDetails['name'] = result;
      update([const Key("chat_group_info")]);
    }
  }

  void setGroupRemark() async {
    var result = await Get.toNamed('/set_group_remark', arguments: {
      'chatGroupId': chatGroupId,
      'remark': chatGroupDetails['groupRemark'] ?? ''
    });
    if (result != null) {
      chatGroupDetails['groupRemark'] = result;
      update([const Key("chat_group_info")]);
    }
  }

  void setGroupNickname() async {
    var result = await Get.toNamed('/set_group_nickname', arguments: {
      'chatGroupId': chatGroupId,
      'name': chatGroupDetails['groupName'] ?? ''
    });
    if (result != null) {
      chatGroupDetails['groupName'] = result;
      update([const Key("chat_group_info")]);
    }
  }

  void chatGroupNotice() async {
    await Get.toNamed('/chat_group_notice', arguments: {
      'chatGroupId': chatGroupId,
      'isOwner': isOwner,
    });
    if (isOwner) {
      onGetGroupChatDetails();
    }
  }

  void chatGroupMember() async {
    await Get.toNamed('/chat_group_member', arguments: {
      'chatGroupId': chatGroupId,
      'isOwner': isOwner,
      'chatGroupDetails': chatGroupDetails
    });
    onGetGroupChatMembers();
    onGetGroupChatDetails();
  }

  void onGroupMemberPress(dynamic member) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUser = prefs.getString('userId')!;
    Get.toNamed('/friend_info', arguments: {
      'friendId': currentUser == member['userId'] ? '0' : member['userId']
    });
  }

  void onQuitGroup(context) async {
    CustomDialog.showTipDialog(context, text: "确定退出该群聊?", onOk: () {
      _chatGroupApi.quitChatGroup(chatGroupId).then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast('退出群聊成功~');
          Get.back(result: true);
        }
      });
    }, onCancel: () {});
  }

  void onDissolveGroup(context) async {
    CustomDialog.showTipDialog(context, text: "确定解散该群聊?", onOk: () {
      _chatGroupApi.dissolveChatGroup(chatGroupId).then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast('解散群聊成功~');
          Get.back(result: true);
        }
      });
    }, onCancel: () {});
  }

  @override
  void onClose() {
    super.onClose();
    _contactsLogic.init();
  }
}
