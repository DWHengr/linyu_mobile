import 'dart:async';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../api/user_api.dart';

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

  set countdownTime(int i) {
    _countdownTime = i;
    super.update([
      const Key("countdown"),
    ]);
  }

  //发送验证码
  void onTapSendMail() async {
    if (countdownTime == 0) {
      //TODO Http请求发送验证码
      final String mail = mailController.text;
      final emailVerificationResult = await _useApi.emailVerification(mail);
      debugPrint(emailVerificationResult.toString());
      if (emailVerificationResult['code'] == 0) {
        Fluttertoast.showToast(
            msg: "发送成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        countdownTime = 30;
        _startCountdownTimer();
      } else {
        Fluttertoast.showToast(
            msg: emailVerificationResult['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

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
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      final publicKeyResult = await _useApi.publicKey();
      if (publicKeyResult['code'] == 0) {
        String key = publicKeyResult['data'];
        final parsedKey = encrypt.RSAKeyParser().parse(key) as RSAPublicKey;
        final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: parsedKey));
        final encryptedPassword = encrypter.encrypt(password).base64;
        final registerResult = await _useApi.register(
            username, account, encryptedPassword, email, code);
        Fluttertoast.showToast(
            msg: registerResult['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: registerResult['code']==0?Colors.green:Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (registerResult['code'] == 0) {
          Get.back();
        }
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
}
