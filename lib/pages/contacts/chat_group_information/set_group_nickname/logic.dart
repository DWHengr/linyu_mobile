import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class SetGroupNameNickLogic extends GetxController {
  final _chatGroupApi = ChatGroupApi();
  final TextEditingController nameController = TextEditingController();
  late String chatGroupId;
  late RxInt nameLength = 0.obs;

  @override
  void onInit() {
    nameController.text = Get.arguments['name'];
    chatGroupId = Get.arguments['chatGroupId'];
    nameLength.value = nameController.text.length;
  }

  void onSetName() async {
    if (nameController.text == null) {
      return;
    }
    final response = await _chatGroupApi.update(
        chatGroupId, 'group_name', nameController.text);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('群昵称设置成功~');
      Get.back(result: nameController.text);
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
