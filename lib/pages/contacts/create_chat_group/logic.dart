import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/String.dart';

class CreateChatGroupLogic extends GetxController {
  final _chatGroupApi = ChatGroupApi();
  late int nameLength = 0;
  final TextEditingController nameController = TextEditingController();

  void onCreateChatGroup() async {
    if (StringUtil.isNullOrEmpty(nameController.text)) {
      CustomFlutterToast.showErrorToast('请输入群名称~');
      return;
    }
    final response = await _chatGroupApi.create(nameController.text);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('创建群聊成功~');
      Get.back(result: true);
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  void onRemarkChanged(String value) {
    nameLength = value.length;
    update([const Key('set_remark')]);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
