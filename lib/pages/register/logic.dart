import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/encrypt.dart';

class RegisterPageLogic extends GetxController {
  final _useApi = UserApi();

  //用户名
  final usernameController = TextEditingController();

  //账号
  final accountController = TextEditingController();

  //密码
  final passwordController = TextEditingController();

  //邮箱
  final mailController = TextEditingController();

  //验证码
  final codeController = TextEditingController();

  //计时器
  late Timer _timer;
  int _countdownTime = 0;
  int get countdownTime => _countdownTime;
  set countdownTime(int value) {
    _countdownTime = value;
    update([
      const Key("countdown"),
    ]);
  }

  int _userTextLength = 0;
  int get userTextLength => _userTextLength;
  set userTextLength(int value) {
    _userTextLength = value;
    update([const Key("register")]);
  }

  int _accountTextLength = 0;
  int get accountTextLength =>_accountTextLength;
  set accountTextLength(int value){
    _accountTextLength = value;
    update([const Key("register")]);
  }

  int _passwordTextLength = 0;
  int get passwordTextLength =>_passwordTextLength;
  set passwordTextLength(int value){
    _passwordTextLength = value;
    update([const Key("register")]);
  }

  //用户名输入长度
  void onUserTextChanged(String value) {
    userTextLength = value.length;
    if (userTextLength >= 30) userTextLength = 30;
  }

  //用户账号输入长度
  void onAccountTextChanged(String value){
    accountTextLength = value.length;
    if (accountTextLength >= 30) accountTextLength = 30;
  }

  //用户密码输入长度
  void onPasswordTextChanged(String value){
    passwordTextLength = value.length;
    if (passwordTextLength >= 16) passwordTextLength = 16;
  }

  //发送验证码
  void onTapSendMail() async {
    if (countdownTime == 0) {
      //TODO Http请求发送验证码
      final String mail = mailController.text;
      final emailVerificationResult = await _useApi.emailVerification(mail);
      if (emailVerificationResult['code'] == 0) {
        Fluttertoast.showToast(
            msg: "发送成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF4C9BFF),
            textColor: Colors.white,
            fontSize: 16.0);
        countdownTime = 30;
        _startCountdownTimer();
      } else {
        Fluttertoast.showToast(
            msg: emailVerificationResult['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  //注册
  void onRegister() async {
    String username = usernameController.text;
    String account = accountController.text;
    String password = passwordController.text;
    String email = mailController.text;
    String code = codeController.text;
    if (username.isEmpty ||
        account.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        code.isEmpty) {
      Fluttertoast.showToast(
          msg: "不能为空，请填写完整！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      final encryptedPassword = await passwordEncrypt(password);
      assert(encryptedPassword != "-1");
      final registerResult = await _useApi.register(
          username, account, encryptedPassword, email, code);
      Fluttertoast.showToast(
          msg: registerResult['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: registerResult['code'] == 0
              ? const Color(0xFF4C9BFF)
              : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (registerResult['code'] == 0) {
        Get.back();
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
    usernameController.dispose();
    accountController.dispose();
    passwordController.dispose();
    mailController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
