import 'package:flutter/material.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'logic.dart';


//页面展示了输入框，输入原密码，新密码，确认密码，提交按钮
//输入框有长度限制，密码输入时，会显示当前输入的长度
//提交按钮根据输入框内容是否相等，来判断是否可以提交、
//提交按钮点击后，会调用业务逻辑，修改密码
class UpdatePasswordPage extends CustomWidget<UpdatePasswordLogic> {
  UpdatePasswordPage({super.key});

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
                "修改密码",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20.0),
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
                      labelText: "原密码",
                      controller: controller.oldPasswordController,
                      obscureText: true,
                      onChanged: controller.onOldPasswordTextChanged,
                      suffix: Text('${controller.oldPasswordTextLength}/16'),
                      inputLimit: 16,
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      labelText: "新密码",
                      controller: controller.newPasswordController,
                      obscureText: true,
                      onChanged: controller.onNewPasswordTextChanged,
                      suffix: Text('${controller.newPasswordTextLength}/16'),
                      inputLimit: 16,
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      labelText: "请确认",
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      onChanged: controller.onConfirmPasswordTextChanged,
                      suffix: Text('${controller.confirmPasswordTextLength}/16'),
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
                          backgroundColor: controller.isConfirmEqualNew?const Color(0xFF4C9BFF):Colors.grey,
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
