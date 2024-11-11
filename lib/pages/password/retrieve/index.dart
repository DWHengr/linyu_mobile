import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'logic.dart';
import 'package:flutter/material.dart';


class RetrievePassword extends CustomWidget<RetrievePasswordLogic> {
  RetrievePassword({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBED7F6), Color(0xFFFFFFFF), Color(0xFFDFF4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  // Logo部分
                  Image.asset(
                    'assets/images/logo.png',
                    height: screenWidth * 0.25,
                    width: screenWidth * 0.25,
                  ),
                  const Text(
                    "找回密码",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
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
                      children: <Widget>[
                        CustomTextField(
                          labelText: "账号",
                          controller: controller.accountController,
                          onChanged: controller.onAccountTextChanged,
                          suffix: Text('${controller.accountTextLength}/30'),
                          inputLimit: 30,
                        ),
                        const SizedBox(height: 15.0),
                        CustomTextField(
                          labelText: "邮箱",
                          controller: controller.mailController,
                        ),
                        const SizedBox(height: 20.0),
                        CountdownRetrievePassword(
                          key: const Key("countdown"),
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                          labelText: "密码",
                          controller: controller.passwordController,
                          obscureText: true,
                          onChanged: controller.onPasswordTextChanged,
                          suffix: Text('${controller.passwordTextLength}/16'),
                          inputLimit: 16,
                        ),
                        const SizedBox(height: 20.0),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: ElevatedButton(
                            // onPressed: ()=>controller.login(context),
                            onPressed: controller.onSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              backgroundColor: const Color(0xFF4C9BFF),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "提  交",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
