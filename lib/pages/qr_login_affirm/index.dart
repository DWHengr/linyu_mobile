import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';

final _userAPi = UserApi();

class QrLoginAffirmPage extends StatefulWidget {
  final String? qrCode;

  const QrLoginAffirmPage({super.key, required this.qrCode});

  @override
  State<StatefulWidget> createState() => _QrLoginAffirmPagePageState();
}

class _QrLoginAffirmPagePageState extends State<QrLoginAffirmPage> {
  void _onQrLogin() {
    _userAPi.qrLogin(widget.qrCode).then((res) {
      if (res['code'] == 0) {
        Fluttertoast.showToast(
            msg: "登录成功~",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF4C9BFF),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      Get.offAllNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('登录确认'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('assets/images/qr-affirm.png', width: 180),
                  const SizedBox(height: 10),
                  const Text(
                    'Linyu电脑版本请求登录',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(text: '确认登录', onTap: _onQrLogin, width: 220),
                  const SizedBox(height: 10),
                  CustomButton(
                      text: '取消', type: 'minor', onTap: () {}, width: 220),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
