import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/chat_group_member.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class ChatGroupMemberLogic extends GetxController {
  final _chatGroupMemberApi = ChatGroupMemberApi();
  final _chatGroupApi = ChatGroupApi();
  final _notifyApi = NotifyApi();
  late Map<String, dynamic> members = {};
  late List<dynamic> memberList = [];
  late List<dynamic> allMemberList = [];
  late String chatGroupId;
  late bool isOwner = false;
  late dynamic chatGroupDetails = {};

  @override
  void onInit() {
    chatGroupId = Get.arguments['chatGroupId'];
    isOwner = Get.arguments['isOwner'] ?? false;
    chatGroupDetails = Get.arguments['chatGroupDetails'] ?? {};
    onGetMembers();
  }

  void onGetMembers() {
    _chatGroupMemberApi.list(chatGroupId).then((res) {
      if (res['code'] == 0) {
        members = res['data'];
        allMemberList = members.values.toList();
        memberList = members.values.toList();
        update([const Key('chat_group_member')]);
      }
    });
  }

  void onKickMember(context, String userId) {
    CustomDialog.showTipDialog(context, text: "确定要将此用户踢出群组?", onOk: () {
      _chatGroupApi.kickChatGroup(chatGroupId, userId).then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast("用户已被踢出群组~");
          onGetMembers();
        }
      });
    }, onCancel: () {});
  }

  void handlerSearchUser(String keyword) {
    if (keyword.isEmpty || keyword == '') {
      memberList = allMemberList;
    } else {
      memberList = allMemberList
          .where((user) =>
              (user['name']?.contains(keyword) ?? false) ||
              (user['remark']?.contains(keyword) ?? false) ||
              (user['groupName']?.contains(keyword) ?? false))
          .toList();
    }
    update([const Key('chat_group_member')]);
  }

  void onInviteFriend() async {
    var result = await Get.toNamed('/user_select',
        arguments: {'onlyUsers': members.keys.toList()});
    if (result != null || result.length > 0) {
      List<dynamic> ids = result.map((item) => item['friendId']).toList();
      _chatGroupApi.inviteMember(chatGroupId, ids).then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast("邀请成功~");
          onGetMembers();
        }
      });
    }
  }

  void onAddFriend(context, String userId) {
    CustomDialog.showTipDialog(context, text: "确定添加该用户为好友?", onOk: () {
      _notifyApi
          .friendApply(userId, '我是 [ ${chatGroupDetails['name']} ] 群成员')
          .then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast("好友申请已发送~");
          onGetMembers();
        }
      });
    }, onCancel: () {});
  }

  void onTransferGroup(context, String userId) {
    CustomDialog.showTipDialog(context, text: "确定将此群组转让给该用户?", onOk: () {
      _chatGroupApi.transferChatGroup(chatGroupId, userId).then((res) {
        if (res['code'] == 0) {
          CustomFlutterToast.showSuccessToast("转让成功~");
          Get.back();
        }
      });
    }, onCancel: () {});
  }
}
