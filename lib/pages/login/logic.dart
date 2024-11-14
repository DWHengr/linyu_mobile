import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/encrypt.dart';

class LoginPageLogic extends GetxController {
  final _useApi = UserApi();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  int _accountTextLength = 0;

  int get accountTextLength => _accountTextLength;

  set accountTextLength(int value) {
    _accountTextLength = value;
    update([const Key("login")]);
  }

  int _passwordTextLength = 0;

  int get passwordTextLength => _passwordTextLength;

  set passwordTextLength(int value) {
    _passwordTextLength = value;
    update([const Key("login")]);
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

  void _dialog(
    String content,
    BuildContext context, [
    String title = '登录失败',
  ]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  void login(context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      _dialog("用户名或密码不能为空~", context = context);
      return;
    }
    final encryptedPassword = await passwordEncrypt(password);
    final loginResult = await _useApi.login(username, encryptedPassword);
    if (loginResult['code'] == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-token', loginResult['data']['token']);
      await prefs.setString('username', loginResult['data']['username']);
      await prefs.setString('userId', loginResult['data']['userId']);
      await prefs.setString('account', loginResult['data']['account']);
      await prefs.setString('portrait', loginResult['data']['portrait']);
      await prefs.setString('sex', loginResult['data']['sex']);
      Get.offAllNamed('/');
    } else {
      _dialog("用户名或密码错误，请重试尝试~", context = context);
    }
  }

  void toRegister() => Get.toNamed('/register');

  void toRetrievePassword() => Get.toNamed('/retrieve_password');

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
