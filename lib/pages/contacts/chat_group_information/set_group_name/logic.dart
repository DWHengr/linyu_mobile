import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class SetGroupNameLogic extends GetxController {
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
    if (nameController.text == null || nameController.text.trim().isEmpty) {
      CustomFlutterToast.showErrorToast('名称不能为空~');
      return;
    }
    final response =
        await _chatGroupApi.updateName(chatGroupId, nameController.text);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast('更新群名称成功~');
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
