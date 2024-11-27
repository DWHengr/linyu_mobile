import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' show Get, GetNavigation, GetxController;
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/chat_group_member.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;

class ChatGroupInformationLogic extends GetxController {
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
    'notice': {},
    'memberNum': '',
    'groupName': '',
    'groupRemark': '',
  };
  late List<dynamic> chatGroupMembers = [];
  final String chatGroupId = Get.arguments['chatGroupId'];

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
        update([const Key('chat_group_info')]);
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
}
