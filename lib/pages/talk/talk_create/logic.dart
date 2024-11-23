import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'
    show Get, GetInstance, GetNavigation, GetxController, TextEditingController;
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linyu_mobile/api/talk_api.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/talk/logic.dart';

class TalkCreateLogic extends GetxController {
  final _talkApi = TalkApi();
  final contentController = TextEditingController();
  final selectedImages = <File>[].obs;
  late List<dynamic> selectedUsers = [];

  TalkLogic get talkLogic => GetInstance().find<TalkLogic>();

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      for (var image in images) {
        selectedImages.add(File(image.path));
      }
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> onUploadImg(String talkId, File img) async {
    Map<String, dynamic> map = {};
    final file = await MultipartFile.fromFile(img.path,
        filename: img.path.split('/').last);
    map['talkId'] = talkId;
    map['name'] = img.path.split('/').last;
    map['size'] = img.lengthSync();
    map["file"] = file;
    FormData formData = FormData.fromMap(map);
    await _talkApi.uploadImg(formData);
  }

  void onCreateTalk() {
    if (contentController.text.isEmpty) {
      CustomFlutterToast.showSuccessToast('内容不能为空~');
      return;
    }
    List permission = selectedUsers.map((user) => user['friendId']).toList();
    _talkApi.create(contentController.text, permission).then((res) async {
      if (res['code'] == 0) {
        CustomFlutterToast.showSuccessToast('发表成功~');
        Get.back();
        for (var img in selectedImages) {
          await onUploadImg(res['data']['id'], img);
        }
        talkLogic.refreshData();
      }
    });
  }

  Future<void> handlerToUserSelect() async {
    var result = await Get.toNamed('/user_select',
        arguments: {'selectedUsers': selectedUsers});
    if (result != null) {
      selectedUsers = result;
    }
    update([const Key('talk_create')]);
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }
}
