import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/qr_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanLogic extends GetxController {
  final _qrApi = QrApi();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  String? qrText;
  final player = AudioPlayer();
  bool isScanning = true;

  @override
  void onReady() {
    super.onReady();
    if (GetPlatform.isAndroid) {
      qrViewController?.pauseCamera();
    }
    qrViewController?.resumeCamera();
  }

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        qrText = scanData.code;
        isScanning = false; // 停止扫描
        controller.pauseCamera(); // 暂停摄像头
        update();
        await player.play(AssetSource('sounds/success.mp3'));
        final result = await _qrApi.status(scanData.code);
        if (result['code'] == 0) {
          switch (result['data']['action']) {
            case 'login':
              Get.toNamed('/qr_login_affirm',
                  arguments: {'qrCode': scanData.code});
              break;
          }
        }
      }
    });
  }

  void restartScanning() {
    qrText = null;
    isScanning = true;
    update();
    qrViewController?.resumeCamera(); // 恢复摄像头
  }

  @override
  void onClose() {
    qrViewController?.dispose();
    player.dispose();
    super.onClose();
  }
}
