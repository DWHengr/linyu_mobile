import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_notice_api.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class ChatGroupNoticeLogic extends GetxController {
  final _chatGroupNoticeApi = ChatGroupNoticeApi();
  late String chatGroupId;
  late List<dynamic> chatGroupNoticeList = [];
  late bool isOwner = false;

  @override
  void onInit() {
    chatGroupId = Get.arguments['chatGroupId'];
    isOwner = Get.arguments['isOwner'] ?? false;
    onGetChatGroupNoticeList();
  }

  void onGetChatGroupNoticeList() {
    _chatGroupNoticeApi.list(chatGroupId).then((res) {
      if (res['code'] == 0) {
        chatGroupNoticeList = res['data'];
        update([const Key('chat_group_notice')]);
      }
    });
  }

  void onDelChatGroupNotice(context, String id) {
    CustomDialog.showTipDialog(
      context,
      text: '确定删除该条公告?',
      onOk: () {
        _chatGroupNoticeApi.delete(chatGroupId, id).then((res) {
          if (res['code'] == 0) {
            CustomFlutterToast.showSuccessToast('删除成功~');
            onGetChatGroupNoticeList();
          }
        });
      },
      onCancel: () {},
    );
  }

  void handlerEditNotice(String id, String content) async {
    var result = await Get.toNamed('/add_chat_group_notice', arguments: {
      'chatGroupId': chatGroupId,
      'chatGroupNoticeId': id,
      'content': content,
    });
    if (result) {
      onGetChatGroupNoticeList();
    }
  }

  void handlerAddNotice() async {
    var result = await Get.toNamed('/add_chat_group_notice', arguments: {
      'chatGroupId': chatGroupId,
    });
    if (result) {
      onGetChatGroupNoticeList();
    }
  }
}
