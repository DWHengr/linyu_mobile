import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
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
                // Logo部分
                const SizedBox(height: 10.0),
                const Text(
                  "重置密码",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "请输入原密码和新密码，确认密码。",
                  style: TextStyle(fontSize: 14),
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
                        labelText: "确认密码",
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        onChanged: controller.onConfirmPasswordTextChanged,
                        suffix:
                            Text('${controller.confirmPasswordTextLength}/16'),
                        inputLimit: 16,
                      ),
                      // const SizedBox(height: 20.0),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  text: "更改密码",
                  onTap: controller.onSubmit,
                  width: MediaQuery.of(context).size.width,
                  type: 'gradient',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
