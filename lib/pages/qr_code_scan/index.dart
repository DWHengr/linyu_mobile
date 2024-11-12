import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'logic.dart';

class QRCodeScanPage extends CustomWidget<QRCodeScanLogic> {
  QRCodeScanPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('扫一扫'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: controller.qrKey,
                  onQRViewCreated: controller.onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: const Color(0xFF4C9BFF),
                    borderRadius: 1,
                    borderLength: 20,
                    borderWidth: 8,
                    cutOutSize: 250,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.tealAccent.withOpacity(0.1),
                  child: const Center(
                    child: Text(
                      '请对准二维码扫描',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (controller.qrText != null && controller.isScanning)
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "扫描成功~",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          if (controller.qrText != null && !controller.isScanning)
            Center(
              child: CustomButton(
                text: '重新扫描',
                onTap: controller.restartScanning,
                type: 'minor',
                width: 120,
              ),
            ),
        ],
      ),
    );
  }
}
