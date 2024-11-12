import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/qr_api.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/pages/qr_login_affirm/index.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final _qrApi = QrApi();

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  final player = AudioPlayer();
  bool _isScanning = true; // 新增扫描状态

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
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
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
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
          if (qrText != null && _isScanning)
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
          if (qrText != null && !_isScanning)
            Center(
              child: CustomButton(
                text: '重新扫描',
                onTap: _restartScanning,
                type: 'minor',
                width: 120,
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isScanning) {
        setState(() {
          qrText = scanData.code;
          _isScanning = false; // 停止扫描
          controller.pauseCamera(); // 暂停摄像头
        });

        await player.play(AssetSource('sounds/success.mp3'));
        final result = await _qrApi.status(scanData.code);
        if (result['code'] == 0) {
          switch (result['data']['action']) {
            case 'login':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QrLoginAffirmPage(qrCode: scanData.code),
                ),
              );
              break;
          }
        }
      }
    });
  }

  void _restartScanning() {
    setState(() {
      qrText = null;
      _isScanning = true;
    });
    controller?.resumeCamera(); // 恢复摄像头
  }

  @override
  void dispose() {
    controller?.dispose();
    player.dispose();
    super.dispose();
  }
}
