import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_notice_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class AddChatGroupNoticeLogic extends GetxController {
  final _chatGroupNoticeApi = ChatGroupNoticeApi();
  final TextEditingController noticeController = TextEditingController();
  late String? chatGroupNoticeId;
  late String chatGroupId;
  late RxInt noticeLength = 0.obs;

  @override
  void onInit() {
    noticeController.text = Get.arguments['content'] ?? '';
    chatGroupNoticeId = Get.arguments['chatGroupNoticeId'];
    chatGroupId = Get.arguments['chatGroupId'];
    noticeLength.value = noticeController.text.length;
  }

  void onAddNotice() async {
    if (noticeController.text == null || noticeController.text.trim().isEmpty) {
      CustomFlutterToast.showErrorToast('公告不能为空~');
      return;
    }
    Map<String, dynamic> response = {'code': 1};
    if (chatGroupNoticeId == null) {
      response =
          await _chatGroupNoticeApi.create(chatGroupId, noticeController.text);
    } else {
      response = await _chatGroupNoticeApi.update(
          chatGroupId, chatGroupNoticeId!, noticeController.text);
    }
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('群公告设置成功~');
      Get.back(result: true);
    } else {
      CustomFlutterToast.showErrorToast('群公告设置失败~');
    }
  }

  @override
  void onClose() {
    noticeController.dispose();
    super.onClose();
  }
}
