import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ImageViewerLogic extends GetxController {
  late final PageController pageController;
  late final List<String> imageUrls;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    imageUrls = Get.arguments['imageUrls'];
    currentIndex.value = Get.arguments['currentIndex'];
    pageController = PageController(initialPage: currentIndex.value);
    super.onInit();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    update();
  }

  Future<void> saveImage() async {
    try {
      // 检查权限
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      // 下载图片
      final response = await http.get(Uri.parse(imageUrls[currentIndex.value]));
      final bytes = response.bodyBytes;
      // 保存到相册
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 100, name: "image_${DateTime.now().millisecondsSinceEpoch}");
      CustomFlutterToast.showSuccessToast("保存成功${result['filePath']}");
    } catch (e) {
      CustomFlutterToast.showSuccessToast("保存失败~");
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
