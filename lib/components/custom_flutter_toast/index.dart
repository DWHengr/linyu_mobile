import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_instance/src/get_instance.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';

class CustomFlutterToast {
  static void showSuccessToast(String msg) {
    GlobalThemeConfig theme = GetInstance().find<GlobalThemeConfig>();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: theme.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showErrorToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
