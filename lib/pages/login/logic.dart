import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/user_api.dart';

class LoginPageLogic extends GetxController {
  final _useApi = UserApi();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Object widgetFilter(LoginPageLogic loginPageLogic){
    return this._useApi;
  }

  void _dialog(context, String content, [String title = '登录失败']) {
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
      _dialog("用户名或密码不能为空~", context);
      return;
    }
    final publicKeyResult = await _useApi.publicKey();
    if (publicKeyResult['code'] != 0) {}
    String key = publicKeyResult['data'];
    final parsedKey = encrypt.RSAKeyParser().parse(key) as RSAPublicKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: parsedKey));
    final encryptedPassword = encrypter.encrypt(password).base64;
    final loginResult = await _useApi.login(username, encryptedPassword);
    if (loginResult['code'] == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-token', loginResult['data']['token']);
      await prefs.setString('username', loginResult['data']['username']);
      await prefs.setString('userId', loginResult['data']['userId']);
      await prefs.setString('account', loginResult['data']['account']);
      await prefs.setString('portrait', loginResult['data']['portrait']);
      Get.offAndToNamed('/');
    } else {
      _dialog("用户名或密码错误，请重试尝试~", context);
    }
  }

  void toRegister()=>Get.toNamed('/register');

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
