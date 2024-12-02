import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileDetailsLogic extends GetxController {
  late String fileName;
  late String fileUrl;
  late String fileType;
  late int fileSize;
  RxDouble downloadProgress = 0.0.obs;
  RxBool isDownloading = false.obs;
  bool isDownloaded = false;
  String? localFilePath;
  CancelToken? cancelToken;

  GlobalData get globalData => GetInstance().find<GlobalData>();

  @override
  void onInit() {
    super.onInit();
    fileName = Get.arguments['fileName'];
    fileUrl = Get.arguments['fileUrl'];
    fileType = Get.arguments['fileType'];
    fileSize = Get.arguments['fileSize'];
    checkFileExists();
  }

  Future<void> checkFileExists() async {
    final localPath = await getLocalFilePath();
    var file = File(localPath);
    if (file.existsSync() && file.lengthSync() == fileSize) {
      isDownloaded = true;
      localFilePath = localPath;
      update([const Key('file_details')]);
    }
  }

  Future<String> getLocalFilePath() async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/${globalData.currentUserAccount}/$fileName';
  }

  Future<void> startDownload() async {
    if (isDownloading.value) {
      return;
    }
    isDownloading.value = true;
    cancelToken = CancelToken();
    try {
      final dio = Dio();
      final localPath = await getLocalFilePath();
      await dio.download(
        fileUrl,
        localPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );
      isDownloaded = true;
      localFilePath = localPath;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        CustomFlutterToast.showSuccessToast('下载已取消~');
      } else {
        CustomFlutterToast.showErrorToast('下载失败，请稍后再试~');
      }
    } finally {
      isDownloading.value = false;
      update([const Key('file_details')]);
    }
  }

  void cancelDownload() {
    if (!isDownloading.value) return;
    cancelToken?.cancel('下载取消');
    downloadProgress.value = 0.0;
    isDownloading.value = false;
    update([const Key('file_details')]);
  }

  Future<void> openFile() async {
    if (localFilePath != null) {
      OpenResult result = await OpenFilex.open(localFilePath!);
      if (result.type == ResultType.noAppToOpen) {
        CustomFlutterToast.showErrorToast('没有找到对应的打开方式~');
      }
      if (result.type == ResultType.permissionDenied) {
        CustomFlutterToast.showErrorToast('权限不足，无法打开文件~');
      }
    }
  }
}
