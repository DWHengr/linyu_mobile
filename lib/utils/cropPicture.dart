import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

typedef UploadPictureCallback = void Function(File picture);

//图片剪切
Future cropPicture(ImageSource? type, UploadPictureCallback uploadPicture) async {
  Get.back();
  final ImagePicker picker = ImagePicker();

  final XFile? pickedFile = await picker.pickImage(
      source: type ?? ImageSource.gallery);

  File? croppedFile = await ImageCropper().cropImage(
    sourcePath: pickedFile!.path,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
        : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
    androidUiSettings: const AndroidUiSettings(
      toolbarTitle: '剪切',
      // toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Color(0xFF4C9BFF),
      dimmedLayerColor: Colors.black54,
      cropFrameColor: Color(0xFF4C9BFF),
      activeControlsWidgetColor: Color(0xFF4C9BFF),
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    iosUiSettings: const IOSUiSettings(
      title: '剪切',
    ),
  );
  if (croppedFile != null) {
    pickedFile.path.split("/");
    uploadPicture(croppedFile);
  }
}
