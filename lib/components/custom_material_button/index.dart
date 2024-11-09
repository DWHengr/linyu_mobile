import 'package:flutter/material.dart';

import '../../pages/register/logic.dart';
import '../../pages/retrieve_password/logic.dart';
import '../custom_text_field/index.dart';
import '../getx_config/config.dart';

class Countdown extends CustomWidget<RegisterPageLogic> {
  Countdown({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return CustomTextField(
      labelText: '验证码',
      hintText: "请输入验证码",
      controller: controller.codeController,
      suffix: controller.mailController.text!=""?Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.onTapSendMail,
            child: Text(
              controller.countdownTime > 0
                  ? '${controller.countdownTime}后重新获取'
                  : '获取验证码',
              style: TextStyle(
                fontSize: 14,
                color: controller.countdownTime > 0
                    ? const Color.fromARGB(255, 183, 184, 195)
                    : const Color.fromARGB(255, 17, 132, 255),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ):null,
    );
  }
}

class Countdown2 extends CustomWidget<RetrievePasswordLogic> {
  Countdown2({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return CustomTextField(
      labelText: '验证码',
      hintText: "请输入验证码",
      controller: controller.codeController,
      suffix: controller.mailController.text!=""?Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.onTapSendMail,
            child: Text(
              controller.countdownTime > 0
                  ? '${controller.countdownTime}后重新获取'
                  : '获取验证码',
              style: TextStyle(
                fontSize: 14,
                color: controller.countdownTime > 0
                    ? const Color.fromARGB(255, 183, 184, 195)
                    : const Color.fromARGB(255, 17, 132, 255),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ):null,
    );
  }
}


class CustomMaterialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;

  const CustomMaterialButton(
      {required this.child,
        required this.onTap,
        this.borderRadius = 10,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
