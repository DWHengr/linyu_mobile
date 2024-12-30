import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' show Get, GetInstance, GetNavigation, GetxController;
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/chat_group_member.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;

class ChatGroupInformationLogic extends GetxController{
  final ContactsLogic _contactsLogic = GetInstance().find<ContactsLogic>();
  final _chatGroupApi = ChatGroupApi();
  final _chatGroupMemberApi = ChatGroupMemberApi();
  final _chatListApi = new ChatListApi();
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
  final String _chatGroupId = Get.arguments['chatGroupId'];
  double _groupMemberWidth = 0;

  double get groupMemberWidth => _groupMemberWidth;

  set groupMemberWidth(double value) {
    _groupMemberWidth = value;
    update([const Key('chat_group_info')]);
  }

  Future<void> _onGetGroupChatDetails() async {
    try {
      final res = await _chatGroupApi.details(_chatGroupId);
      if (res['code'] == 0) {
        chatGroupDetails = res['data'];
        final prefs = await SharedPreferences.getInstance();
        _currentUserId = prefs.getString('userId');
        isOwner = _currentUserId == chatGroupDetails['ownerUserId'];
        update([const Key('chat_group_info')]);
      } else {
        CustomFlutterToast.showErrorToast('获取群聊详情失败: ${res['msg']}');
      }
    } catch (error) {
      CustomFlutterToast.showErrorToast('获取群聊详情时发生错误: $error');
    }
  }

  void _onGetGroupChatMembers() async {
    try {
      final res = await _chatGroupMemberApi.listPage(_chatGroupId);
      if (res['code'] == 0) {
        chatGroupMembers = res['data'];
        final double calculatedWidth = chatGroupMembers.length * 40 + 10;
        groupMemberWidth = calculatedWidth.clamp(0, 190);
        // update([const Key('chat_group_info')]);
      } else {
        CustomFlutterToast.showErrorToast('获取群聊成员失败: ${res['msg']}');
      }
    } catch (error) {
      CustomFlutterToast.showErrorToast('获取群聊成员时发生错误: $error');
    }
  }

  Future<void> _onUpdateChatGroupPortrait(File picture) async {
    try {
      final filename = picture.path.split('/').last;
      final file =
      await MultipartFile.fromFile(picture.path, filename: filename);
      final formData = FormData.fromMap({
        'type': 'image/jpeg',
        'name': filename,
        'size': picture.lengthSync(),
        'file': file,
        'groupId': _chatGroupId,
      });

      final result = await _chatGroupApi.upload(formData);
      if (result['code'] == 0) {
        CustomFlutterToast.showSuccessToast('头像修改成功');
        chatGroupDetails['portrait'] = result['data'];
        update([const Key("chat_group_info")]);
      } else {
        CustomFlutterToast.showErrorToast(result['msg']);
      }
    } catch (error) {
      CustomFlutterToast.showErrorToast('头像上传失败: $error');
    }
  }

  void selectPortrait() {
    try {
      // 确保 portrait 不为 null
      final String? imageUrl = chatGroupDetails['portrait'];
      if (imageUrl == null) {
        CustomFlutterToast.showErrorToast('群聊头像URL获取失败');
        return;
      }

      Get.toNamed('/image_viewer_update', arguments: {
        'imageUrl': imageUrl,
        'onConfirm': _onUpdateChatGroupPortrait,
        'isUpdate': isOwner
      });
    } catch (error) {
      CustomFlutterToast.showErrorToast('选择群聊头像时发生错误: $error');
    }
  }

  void setGroupName() async {
    try {
      var result = await Get.toNamed('/set_group_name', arguments: {
        'chatGroupId': _chatGroupId,
        'name': chatGroupDetails['name']
      });
      if (result != null && chatGroupDetails['name'] != result) {
        chatGroupDetails['name'] = result;
        update([const Key("chat_group_info")]);
      }
    } catch (error) {
      CustomFlutterToast.showErrorToast('设置群聊名称时发生错误: $error');
    }
  }

  void setGroupRemark() async {
    try {
      var result = await Get.toNamed('/set_group_remark', arguments: {
        'chatGroupId': _chatGroupId,
        'remark': chatGroupDetails['groupRemark'] ?? ''
      });
      if (result != null && chatGroupDetails['groupRemark'] != result) {
        chatGroupDetails['groupRemark'] = result;
        update([const Key("chat_group_info")]);
      }
    } catch (error) {
      CustomFlutterToast.showErrorToast('设置群聊备注时发生错误: $error');
    }
  }

  void setGroupNickname() async {
    try {
      var groupName = chatGroupDetails['groupName'] ?? '';
      var result = await Get.toNamed('/set_group_nickname',
          arguments: {'chatGroupId': _chatGroupId, 'name': groupName});
      if (result == null) return; // 如果没有结果，提前返回

      chatGroupDetails['groupName'] = result;
      update([const Key("chat_group_info")]);
    } catch (error) {
      CustomFlutterToast.showErrorToast('设置群聊昵称时发生错误: $error');
    }
  }

  void chatGroupNotice() async {
    try {
      await Get.toNamed('/chat_group_notice', arguments: {
        'chatGroupId': _chatGroupId,
        'isOwner': isOwner,
      });
      if (isOwner) await _onGetGroupChatDetails();
    } catch (error) {
      CustomFlutterToast.showErrorToast('获取群聊公告时发生错误: $error');
    }
  }

  void chatGroupMember() async {
    try {
      await Get.toNamed('/chat_group_member', arguments: {
        'chatGroupId': _chatGroupId,
        'isOwner': isOwner,
        'chatGroupDetails': chatGroupDetails
      });
      // 仅在必要时更新成员和详情，例如用户在新页面进行了修改
      // 这里假设在返回时需要刷新数据
      _onGetGroupChatMembers();
      _onGetGroupChatDetails();
    } catch (error) {
      CustomFlutterToast.showErrorToast('获取群聊成员或详情时发生错误: $error');
    }
  }

  void onGroupMemberPress(dynamic member) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUser = prefs.getString('userId'); // 修改为String?
      if (currentUser == null) {
        CustomFlutterToast.showErrorToast('当前用户ID获取失败');
        return; // 如果用户ID为null，直接返回，不继续执行
      }

      Get.toNamed('/friend_info', arguments: {
        'friendId': currentUser == member['userId'] ? '0' : member['userId']
      });
    } catch (error) {
      CustomFlutterToast.showErrorToast('获取用户信息时发生错误: $error');
    }
  }

  void onQuitGroup(BuildContext context) async => CustomDialog.showTipDialog(
    context,
    text: "确定退出该群聊?",
    onOk: () async {
      try {
        final res = await _chatGroupApi.quitChatGroup(_chatGroupId);
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast('退出群聊成功~');
          Get.back(result: true);
        } else {
          CustomFlutterToast.showErrorToast('退出群聊失败: ${res['msg']}');
        }
      } catch (error) {
        CustomFlutterToast.showErrorToast('退出群聊时发生错误: $error');
      }
    },
    onCancel: () {},
  );

  void onDissolveGroup(BuildContext context) async =>
      CustomDialog.showTipDialog(
        context,
        text: "确定解散该群聊?",
        onOk: () async {
          try {
            final res = await _chatGroupApi.dissolveChatGroup(_chatGroupId);
            if (res['code'] == 0) {
              CustomFlutterToast.showSuccessToast('解散群聊成功~');
              Get.back(result: true);
            } else {
              CustomFlutterToast.showErrorToast('解散群聊失败: ${res['msg']}');
            }
          } catch (error) {
            CustomFlutterToast.showErrorToast('解散群聊时发生错误: $error');
          }
        },
        onCancel: () {},
      );

  void onToSendGroupMsg() {
    _chatListApi.createChat(_chatGroupId, type: 'group').then((res) {
      if (res['code'] == 0) {
        Get.offAndToNamed('/chat_frame', arguments: {
          'chatInfo': res['data'],
        });
      } else {
        // 增加错误处理机制
        CustomFlutterToast.showErrorToast('创建群聊消息失败: ${res['msg']}');
      }
    }).catchError((error) {
      // 捕获并处理可能的异常
      CustomFlutterToast.showErrorToast('发送群聊消息时发生错误: $error');
    });
  }

  @override
  void onInit() {
    _onGetGroupChatDetails();
    _onGetGroupChatMembers();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _contactsLogic.init();
  }
}
