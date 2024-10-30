import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import '../../components/custom_text_field/index.dart';

final _useApi = UserApi();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    final publicKeyResult = await _useApi.publicKey();
    if (publicKeyResult['code'] != 0) {}
    String key = publicKeyResult['data'];
    final parsedKey = encrypt.RSAKeyParser().parse(key) as RSAPublicKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: parsedKey));
    final encryptedPassword = encrypter.encrypt(password).base64;
    final loginResult = await _useApi.login(username, encryptedPassword);
    print(loginResult['code']);
    if (loginResult['code'] == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("登录成功"),
          content: Text("欢迎，${loginResult['data']}!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("确定"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("登录失败"),
          content: Text("用户名或密码错误，请重试"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("确定"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBED7F6), Color(0xFFFFFFFF), Color(0xFFDFF4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 应用 Logo 和名称
                Image.asset(
                  'assets/images/logo.png', // 确保在pubspec.yaml中添加了logo图片路径
                  height: screenWidth * 0.3,
                  width: screenWidth * 0.3,
                ),
                const Text(
                  "林语",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 32.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: const Color(0xFFF2F2F2), // 边框颜色
                      width: 1.0, // 边框宽度
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        labelText: "账号",
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        labelText: "密码",
                        controller: _passwordController,
                        obscureText: true, // 密码输入框
                      ),
                      const SizedBox(height: 20.0),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
