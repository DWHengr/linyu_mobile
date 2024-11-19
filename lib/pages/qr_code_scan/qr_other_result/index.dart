import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_other_result/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class QrOtherResultPage extends CustomWidget<QrOtherResultLogic> {
  QrOtherResultPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('扫描结果'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              const Icon(
                IconData(0xe66a, fontFamily: 'IconFont'),
                size: 100,
                color: Color(0xCCFF4C4C),
              ),
              const SizedBox(height: 20),
              Text(controller.text, style: const TextStyle(fontSize: 18))
            ],
          ),
        ),
      ),
    );
  }
}
