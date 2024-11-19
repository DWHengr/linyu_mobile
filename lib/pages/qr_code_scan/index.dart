import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'logic.dart';

class QRCodeScanPage extends CustomWidget<QRCodeScanLogic> {
  QRCodeScanPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('扫一扫'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: MobileScanner(
                  controller: controller.mobileScannerController,
                  onDetect: controller.onDetect,
                  overlayBuilder: (context, constraints) {
                    return Stack(
                      children: [
                        CustomPaint(
                          size:
                              Size(constraints.maxWidth, constraints.maxHeight),
                          painter: ScannerOverlayPainter(),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              ...buildCorners(constraints),
                              Positioned(
                                bottom: 40,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.flashlight_on,
                                        color: Colors.white),
                                    onPressed: () {
                                      controller.mobileScannerController
                                          .toggleTorch();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFF9FBFF),
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

  List<Widget> buildCorners(constraints) {
    return [
      // 左上角
      Positioned(
        top: constraints.maxHeight / 2 - 125,
        left: constraints.maxWidth / 2 - 125,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.primaryColor, width: 4),
              left: BorderSide(color: theme.primaryColor, width: 4),
            ),
          ),
        ),
      ),
      // 右上角
      Positioned(
        top: constraints.maxHeight / 2 - 125,
        right: constraints.maxWidth / 2 - 125,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.primaryColor, width: 4),
              right: BorderSide(color: theme.primaryColor, width: 4),
            ),
          ),
        ),
      ),
      // 左下角
      Positioned(
        bottom: constraints.maxHeight / 2 - 125,
        left: constraints.maxWidth / 2 - 125,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.primaryColor, width: 4),
              left: BorderSide(color: theme.primaryColor, width: 4),
            ),
          ),
        ),
      ),
      // 右下角
      Positioned(
        bottom: constraints.maxHeight / 2 - 125,
        right: constraints.maxWidth / 2 - 125,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.primaryColor, width: 4),
              right: BorderSide(color: theme.primaryColor, width: 4),
            ),
          ),
        ),
      ),
    ];
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 240,
      height: 240,
    );
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        centerRect,
        const Radius.circular(1),
      ));
    canvas.drawPath(path..fillType = PathFillType.evenOdd, paint);
  }
}
