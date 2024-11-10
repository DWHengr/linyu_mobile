import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../api/user_api.dart';
import '../../../utils/encrypt.dart';

class RetrievePasswordLogic extends GetxController{

  final _useApi = UserApi();


  //账号
  final accountController = TextEditingController();

  //密码
  final passwordController = TextEditingController();

  //邮箱
  final mailController = TextEditingController();

  //验证码
  final codeController = TextEditingController();

  int _countdownTime = 0;

  //计时器
  late Timer _timer;

  int get countdownTime => _countdownTime;

  set countdownTime(int i) {
    _countdownTime = i;
    update([
      const Key("countdown"),
    ]);
  }

  int _accountTextLength = 0;
  int get accountTextLength =>_accountTextLength;
  set accountTextLength(int i){
    _accountTextLength = i;
    update([const Key("retrieve_password")]);
  }

  int _passwordTextLength = 0;
  int get passwordTextLength =>_passwordTextLength;
  set passwordTextLength(int i){
    _passwordTextLength = i;
    update([const Key("retrieve_password")]);
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

  void onSubmit() async {
    String account = accountController.text;
    String password = passwordController.text;
    String email = mailController.text;
    String code = codeController.text;
    if (account.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        code.isEmpty) {
      Fluttertoast.showToast(
          msg: "不能为空，请填写完整！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFF4C9BFF),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {

      final encryptedPassword =await passwordEncrypter(password);
      assert (encryptedPassword!="-1");
      final passwordForgetReslut = await _useApi.forget(account, encryptedPassword, email, code);
        Fluttertoast.showToast(
            msg: passwordForgetReslut['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: passwordForgetReslut['code']==0?const Color(0xFF4C9BFF):Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (passwordForgetReslut['code'] == 0) {
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
    accountController.dispose();
    passwordController.dispose();
    mailController.dispose();
    codeController.dispose();
    super.onClose();
  }

}
