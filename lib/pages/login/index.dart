import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_gradient_line/index.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/components/custom_shadow_text/index.dart';
import 'package:linyu_mobile/pages/login/logic.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class LoginPage extends CustomWidget<LoginPageLogic> {
  LoginPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDFF4FF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  const SizedBox(height: 40.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomShadowText(
                              text: 'HELLO',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              shadowTop: 22,
                            ),
                            Text(
                              "欢迎使用，林语",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 120,
                            ),
                            child: Image.asset(
                              'assets/images/logo-login.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // 登录框部分
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: const Color(0xFFF2F2F2),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            hintText: '请输入账号',
                            iconData:
                                const IconData(0xe60d, fontFamily: 'IconFont'),
                            controller: controller.usernameController,
                            inputLimit: 30,
                            onChanged: controller.onAccountTextChanged,
                            suffix: Text('${controller.accountTextLength}/30'),
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            hintText: '请输入密码',
                            iconData:
                                const IconData(0xe620, fontFamily: 'IconFont'),
                            controller: controller.passwordController,
                            obscureText: true,
                            inputLimit: 16,
                            onChanged: controller.onPasswordTextChanged,
                            suffix: Text('${controller.passwordTextLength}/16'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    controller.toRetrievePassword(),
                                child: const Text(
                                  "忘记密码?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFb0b0ba),
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CustomButton(
                            text: '立即登录',
                            type: 'gradient',
                            onTap: () => controller.login(context),
                            width: MediaQuery.of(context).size.width,
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "没有账号?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFb0b0ba),
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () => controller.toRegister(),
                                child: const Text(
                                  "立即注册",
                                  style: TextStyle(
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomGradientLine(
                                      width: 80,
                                      height: 1.5,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFFb0b0ba)
                                        ],
                                      ),
                                    ),
                                    Text(
                                      " 相关地址 ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFb0b0ba),
                                      ),
                                    ),
                                    CustomGradientLine(
                                      width: 80,
                                      height: 1.5,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFb0b0ba),
                                          Colors.white
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomMaterialButton(
                                      child: const Icon(
                                        IconData(0xe6f6,
                                            fontFamily: 'IconFont'),
                                        size: 36.0,
                                        color: Color(0xFFb0b0ba),
                                      ),
                                      onTap: () => controller.launchURL(
                                          'https://github.com/DWHengr/linyu_mobile'),
                                    ),
                                    const SizedBox(width: 15),
                                    CustomMaterialButton(
                                      child: const Icon(
                                        IconData(0xe600,
                                            fontFamily: 'IconFont'),
                                        size: 36.0,
                                        color: Color(0xFFb0b0ba),
                                      ),
                                      onTap: () => controller.launchURL(
                                          'https://space.bilibili.com/135427028/channel/series'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
