import 'dart:io';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/cropPicture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ImageViewerUpdateLogic extends GetxController {
  late RxString imageUrl = ''.obs;
  late RxString text = ''.obs;
  late UploadPictureCallback onConfirm;
  late RxBool isUpdate = true.obs;

  @override
  void onInit() {
    imageUrl.value = Get.arguments['imageUrl'] ?? '';
    text.value = Get.arguments['text'] ?? '更改头像';
    onConfirm = Get.arguments['onConfirm'] ?? (File file) async {};
    isUpdate.value = Get.arguments['isUpdate'] ?? true;
    super.onInit();
  }

  Future cropChatBackgroundPicture(ImageSource? type) async =>
      cropPicture(type, onUpdate);

  Future<void> saveImage() async {
    try {
      // 检查权限
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      // 下载图片
      final response = await http.get(Uri.parse(imageUrl.value));
      final bytes = response.bodyBytes;
      // 保存到相册
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 100, name: "image_${DateTime.now().millisecondsSinceEpoch}");
      CustomFlutterToast.showSuccessToast("保存成功${result['filePath']}");
    } catch (e) {
      CustomFlutterToast.showSuccessToast("保存失败~");
    }
  }

  Future<void> onUpdate(File file) async {
    onConfirm(file);
    Get.back();
  }
}
