import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/mine/mine_qr_code/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MineQRCodePage extends CustomWidget<MineQRCodeLogic> {
  MineQRCodePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDFF4FF), Color(0xFFFFFFFF)],
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
                            child: const CustomPortrait(
                                url:
                                    'https://tse3-mm.cn.bing.net/th/id/OIP-C.ruq8qPQn8b_W0prkr4eucQAAAA?rs=1&pid=ImgDetMain',
                                size: 80,
                                radius: 40),
                          ),
                          const Text(
                            'Heath',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'heath',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF7D7D7D)),
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center, // 确保子组件居中对齐
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFF40A9FF),
                                        Color(0xFFA0D9F6)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: QrImageView(
                                    data: '1234567890',
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
                                  child:
                                      Image.asset('assets/images/logo-qr.png'),
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
