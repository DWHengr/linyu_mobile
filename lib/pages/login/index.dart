import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/index.dart';
import '../../components/custom_text_field/index.dart';

final _useApi = UserApi();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showDialog(String content, [String title = '登录失败']) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("确定"),
          ),
        ],
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      _showDialog("用户名或密码不能为空~");
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
        (route) => false,
      );
    } else {
      _showDialog("用户名或密码错误，请重试尝试~");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    "林语",
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
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 15.0),
                        CustomTextField(
                          labelText: "密码",
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20.0),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              backgroundColor: const Color(0xFF4C9BFF),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "登  录",
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
