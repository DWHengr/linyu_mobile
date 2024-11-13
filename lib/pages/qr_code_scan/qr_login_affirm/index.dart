import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'logic.dart';

class QrLoginAffirmPage extends CustomWidget<QRLoginAffirmLogic> {
  QrLoginAffirmPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('登录确认'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('assets/images/qr-affirm.png', width: 180),
                  const SizedBox(height: 10),
                  const Text(
                    'Linyu电脑版本请求登录',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                      text: '确认登录', onTap: controller.onQrLogin, width: 220),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
