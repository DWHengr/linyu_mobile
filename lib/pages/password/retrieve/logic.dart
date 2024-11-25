import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/encrypt.dart';

class RetrievePasswordLogic extends GetxController {
  final _useApi = UserApi();

  //账号
  final accountController = TextEditingController();

  //密码
  final passwordController = TextEditingController();

  //验证码
  final codeController = TextEditingController();

  int _countdownTime = 0;

  //计时器
  late Timer _timer;

  int get countdownTime => _countdownTime;

  set countdownTime(int value) {
    _countdownTime = value;
    update([
      const Key("retrieve_password"),
    ]);
  }

  int _accountTextLength = 0;

  int get accountTextLength => _accountTextLength;

  set accountTextLength(int value) {
    _accountTextLength = value;
    update([const Key("retrieve_password")]);
  }

  int _passwordTextLength = 0;

  int get passwordTextLength => _passwordTextLength;

  set passwordTextLength(int value) {
    _passwordTextLength = value;
    update([const Key("retrieve_password")]);
  }

  //发送验证码
  void onTapSendMail() async {
    if (countdownTime == 0) {
      final String account = accountController.text;
      final emailVerificationResult =
          await _useApi.emailVerificationByAccount(account);
      if (emailVerificationResult['code'] == 0) {
        CustomFlutterToast.showSuccessToast('发送成功~');
        countdownTime = 30;
        _startCountdownTimer();
      } else {
        CustomFlutterToast.showErrorToast(emailVerificationResult['msg']);
      }
    }
  }

  //用户账号输入长度
  void onAccountTextChanged(String value) {
    accountTextLength = value.length;
    if (accountTextLength >= 30) accountTextLength = 30;
  }

  //用户密码输入长度
  void onPasswordTextChanged(String value) {
    passwordTextLength = value.length;
    if (passwordTextLength >= 16) passwordTextLength = 16;
  }

  void onSubmit() async {
    String account = accountController.text;
    String password = passwordController.text;
    String code = codeController.text;
    if (account.isEmpty || password.isEmpty || code.isEmpty) {
      CustomFlutterToast.showSuccessToast('不能为空，请填写完整！');
    } else {
      final encryptedPassword = await passwordEncrypt(password);
      assert(encryptedPassword != "-1");
      final passwordForgetResult =
          await _useApi.forget(account, encryptedPassword, code);
      if (passwordForgetResult['code'] == 0) {
        CustomFlutterToast.showSuccessToast(passwordForgetResult['msg']);
        Get.back();
      } else {
        CustomFlutterToast.showErrorToast(passwordForgetResult['msg']);
      }
    }
  }

  //开始倒计时
  void _startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    callback(timer) => {
          if (countdownTime < 1)
            {_timer.cancel()}
          else
            {countdownTime = countdownTime - 1}
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
