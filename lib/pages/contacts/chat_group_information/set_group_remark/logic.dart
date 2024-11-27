import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class SetGroupRemarkLogic extends GetxController {
  final _chatGroupApi = ChatGroupApi();
  final TextEditingController remarkController = TextEditingController();
  late String chatGroupId;
  late RxInt remarkLength = 0.obs;

  @override
  void onInit() {
    remarkController.text = Get.arguments['remark'];
    chatGroupId = Get.arguments['chatGroupId'];
    remarkLength.value = remarkController.text.length;
  }

  void onSetName() async {
    if (remarkController.text == null) {
      return;
    }
    final response = await _chatGroupApi.update(
        chatGroupId, 'group_remark', remarkController.text);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('备注修改成功~');
      Get.back(result: remarkController.text);
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }
}
