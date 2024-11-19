import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_label_value/index.dart';
import 'package:linyu_mobile/pages/mine/about/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class AboutPage extends CustomWidget<AboutLogic> {
  AboutPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.minorColor, const Color(0xFFFFFFFF)],
          // 渐变颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle('关于我们'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 80,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                "assets/images/linyu.png",
                height: 30,
              ),
              const SizedBox(height: 30),
              const CustomLabelValue(label: '作者', value: "Heath", width: 80),
              const SizedBox(height: 1),
              const CustomLabelValue(
                  label: 'QQ群', value: "729158695", width: 80),
              const SizedBox(height: 1),
              const CustomLabelValue(
                  label: '开源地址',
                  value: "https://github.com/DWHengr/linyu_mobile",
                  width: 80),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "基于",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    "assets/images/flutter.png",
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "开发",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
