import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/qr_api.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanLogic extends GetxController {
  final _qrApi = QrApi();
  final player = AudioPlayer();
  String? qrText;
  bool isScanning = true;

  final mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  void onDetect(BarcodeCapture capture) async {
    if (isScanning && capture.barcodes.isNotEmpty) {
      final barcode = capture.barcodes.first;
      qrText = barcode.rawValue;
      isScanning = false;
      mobileScannerController.stop();
      update([const Key("qr_code_scan")]);
      await player.play(AssetSource('sounds/success.mp3'));
      final result = await _qrApi.status(qrText!);
      if (result['code'] == 0) {
        switch (result['data']['action']) {
          case 'login':
            Get.toNamed('/qr_login_affirm', arguments: {'qrCode': qrText});
            break;
          case 'mine':
            Get.toNamed('/qr_friend_affirm',
                arguments: {'result': result['data']['extend']});
            break;
          default:
            Get.toNamed('/qr_other_result',
                arguments: {'text': "二维码内容无法识别或已失效"});
            break;
        }
      } else {
        Get.toNamed('/qr_other_result', arguments: {'text': "二维码内容无法识别或已失效"});
      }
    }
  }

  void restartScanning() {
    qrText = null;
    isScanning = true;
    mobileScannerController.start();
    update([const Key("qr_code_scan")]);
  }

  @override
  void onClose() {
    mobileScannerController.dispose();
    player.dispose();
    super.onClose();
  }
}
