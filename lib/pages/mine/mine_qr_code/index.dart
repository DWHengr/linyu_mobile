import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';

class MineQRCodePage extends CustomWidget<MineQRCodeLogic> {
  MineQRCodePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.minorColor, const Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, -40),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: CustomPortrait(
                                url: controller.currentUserInfo['portrait'] ??
                                    '',
                                size: 80,
                                radius: 40),
                          ),
                          Text(
                            controller.currentUserInfo['name'] ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            controller.currentUserInfo['account'] ?? '',
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF7D7D7D)),
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center, // 确保子组件居中对齐
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: [
                                        theme.primaryColor,
                                        theme.qrColor
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: QrImageView(
                                    data: controller.qrCode,
                                    version: QrVersions.auto,
                                    padding: const EdgeInsets.all(5),
                                    size: 200.0,
                                    eyeStyle: const QrEyeStyle(
                                      color: Colors.black,
                                    ),
                                    embeddedImageStyle:
                                        const QrEmbeddedImageStyle(
                                      size: Size(50, 50),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                      'assets/images/logo-qr-${theme.themeMode}.png'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("扫描二维码，添加我为好友")
            ],
          )),
    );
  }
}
