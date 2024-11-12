import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';

class QRLoginAffirmLogic extends GetxController {
  final _userAPi = UserApi();
  late final String qrCode;

  @override
  void onInit() {
    qrCode = Get.arguments['qrCode'];
  }

  void onQrLogin() {
    _userAPi.qrLogin(qrCode).then((res) {
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
      Get.until((route) => Get.currentRoute == "/");
    });
  }
}
