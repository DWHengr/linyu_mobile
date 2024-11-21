import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalThemeConfig extends GetxController {
  late RxString themeMode = 'blue'.obs;

  void changeThemeMode(String mode) {
    themeMode.value = mode;
    update();
  }

  //主题色
  Color get primaryColor {
    switch (themeMode.value) {
      case 'blue':
        return const Color(0xFF4C9BFF);
      case 'pink':
        return const Color(0xFFFFA0CF);
      default:
        return const Color(0xFF4C9BFF);
    }
  }

  Color get boldColor {
    switch (themeMode.value) {
      case 'blue':
        return const Color(0xFF0060D9);
      case 'pink':
        return const Color(0xFFFF53A8);
      default:
        return const Color(0xFF0060D9);
    }
  }

  Color get minorColor {
    switch (themeMode.value) {
      case 'blue':
        return const Color(0xFFDFF4FF);
      case 'pink':
        return const Color(0xFFFBEBFF);
      default:
        return const Color(0xFFDFF4FF);
    }
  }

  Color get qrColor {
    switch (themeMode.value) {
      case 'blue':
        return const Color(0xFFA0D9F6);
      case 'pink':
        return const Color(0xFFF5CFFF);
      default:
        return const Color(0xFFA0D9F6);
    }
  }

  //搜索框背景色
  Color get searchBarColor {
    switch (themeMode.value) {
      case 'blue':
        return const Color(0xFFE3ECFF);
      case 'pink':
        return const Color(0xFFFBEDFF);
      default:
        return const Color(0xFFE3ECFF);
    }
  }
}
