import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/pages/file_details/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FileDetailsPage extends CustomWidget<FileDetailsLogic> {
  FileDetailsPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文件详情'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 80),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/file-${theme.themeMode}.png',
                    width: 70,
                  ),
                  Transform.translate(
                    offset: const Offset(-3, 3),
                    child: Text(
                      controller.fileType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(controller.fileName, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                '文件大小：${StringUtil.formatSize(controller.fileSize)}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              if (controller.isDownloaded)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomButton(text: '用其他应用打开', onTap: controller.openFile)
                  ],
                )
              else
                Obx(() {
                  if (!controller.isDownloading.value) {
                    // 开始下载按钮
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        CustomButton(
                          text: '开始下载',
                          onTap: controller.startDownload,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          minHeight: 5,
                          value: controller.downloadProgress.value,
                          color: theme.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        const SizedBox(height: 5),
                        CustomButton(
                          text: '取消下载',
                          onTap: controller.cancelDownload,
                        ),
                      ],
                    );
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }
}
