import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'logic.dart';
import 'package:flutter/material.dart';

/// 找回密码页面
/// 包含账号、邮箱、验证码、密码输入框、提交按钮等
/// 点击获取验证码按钮后，会发送请求到服务器，生成验证码并发送到邮箱，验证码有效期为5分钟
/// 点击提交按钮后，会发送请求到服务器，验证账号、邮箱、验证码是否正确，正确则修改密码
class RetrievePassword extends CustomWidget<RetrievePasswordLogic> {
  RetrievePassword({super.key});

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
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                const Text(
                  "找回密码",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "请输入账号，验证码，新密码。验证码会发送到账号所对应的邮箱内。",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20.0),
                // 登录框部分
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: const Color(0xFFF2F2F2),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        labelText: "账号",
                        controller: controller.accountController,
                        onChanged: controller.onAccountTextChanged,
                        suffix: Text('${controller.accountTextLength}/30'),
                        inputLimit: 30,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        labelText: '验证码',
                        hintText: "请输入验证码",
                        controller: controller.codeController,
                        suffix: controller.accountController.text != ""
                            ? Row(
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
                                            ? const Color.fromARGB(
                                                255, 183, 184, 195)
                                            : const Color.fromARGB(
                                                255, 17, 132, 255),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                ],
                              )
                            : null,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        labelText: "新密码",
                        controller: controller.passwordController,
                        obscureText: true,
                        onChanged: controller.onPasswordTextChanged,
                        suffix: Text('${controller.passwordTextLength}/16'),
                        inputLimit: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  text: "确 定",
                  onTap: controller.onSubmit,
                  width: MediaQuery.of(context).size.width,
                  type: 'gradient',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
