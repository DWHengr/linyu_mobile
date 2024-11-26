import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MineLogic extends GetxController {
  late dynamic currentUserInfo = {};
  final GlobalThemeConfig _theme = GetInstance().find<GlobalThemeConfig>();

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserInfo['name'] = prefs.getString('username');
    currentUserInfo['portrait'] = prefs.getString('portrait');
    currentUserInfo['account'] = prefs.getString('account');
    currentUserInfo['sex'] = prefs.getString('sex');
    update([const Key("mine")]);
  }

  void handlerLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _theme.changeThemeMode("blue");
    Get.offAllNamed('/login');
  }
}
