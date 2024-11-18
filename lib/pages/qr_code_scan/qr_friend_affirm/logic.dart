import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/notify_api.dart';

class QRFriendAffirmLogic extends GetxController {
  final _notifyApi = NotifyApi();
  late final dynamic result;

  @override
  void onInit() {
    super.onInit();
    result = Get.arguments['result'];
  }

  void onAddFriend() {
    _notifyApi.friendApply(result['id'], "通过二维码添加好友").then((res) {
      if (res['code'] == 0) {
        Fluttertoast.showToast(
            msg: "请求成功~",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF4C9BFF),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      // Get.until((route) => Get.currentRoute == "/");
    });
  }
}
