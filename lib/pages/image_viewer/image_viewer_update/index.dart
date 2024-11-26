import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/pages/image_viewer/image_viewer_update/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerUpdatePage extends CustomWidget<ImageViewerUpdateLogic> {
  ImageViewerUpdatePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Obx(
                () => PhotoView(
                  minScale: PhotoViewComputedScale.contained * 0.5,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  imageProvider: NetworkImage(controller.imageUrl.value),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(
              () => CustomButton(
                text: controller.text.value,
                onTap: () => _showDialog(context),
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: '保存图片',
              onTap: () => controller.saveImage(),
              type: 'minor',
              width: MediaQuery.of(context).size.width / 2,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('图库'),
              onTap: () => controller.cropChatBackgroundPicture(null),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () =>
                  controller.cropChatBackgroundPicture(ImageSource.camera),
            ),
          ],
        );
      },
    );
  }
}
