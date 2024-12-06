import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/encrypt.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPageLogic extends GetxController {
  final _useApi = UserApi();

  RxInt accountTextLength = 0.obs;

  RxInt passwordTextLength = 0.obs;

//用户账号输入长度
  void onAccountTextChanged(String value) {
    accountTextLength.value = value.length;
    if (accountTextLength.value >= 30) accountTextLength.value = 30;
  }

//用户密码输入长度
  void onPasswordTextChanged(String value) {
    passwordTextLength.value = value.length;
    if (passwordTextLength.value >= 16) passwordTextLength.value = 16;
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

  void login(context, username, password) async {
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
      await prefs.setString('sex', loginResult['data']['sex'] ?? '男');
      Get.offAllNamed('/?sex=${loginResult['data']['sex']}');
    } else {
      _dialog("用户名或密码错误，请重试尝试~", context = context);
    }
  }

  void toRegister() => Get.toNamed('/register');

  void toRetrievePassword() => Get.toNamed('/retrieve_password');

  Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
