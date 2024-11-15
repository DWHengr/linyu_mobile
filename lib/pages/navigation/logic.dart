import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';

class NavigationLogic extends GetxController {
  late int currentIndex = 0;

  @override
  void onInit() {
    late String sex = Get.parameters['sex'] ?? "男";
    GlobalThemeConfig theme = GetInstance().find<GlobalThemeConfig>();
    theme.changeThemeMode(sex == "女" ? 'pink' : 'blue');
  }

  final List<String> selectedIcons = [
    'chat',
    'user',
    'talk',
    'mine',
  ];

  final List<String> unselectedIcons = [
    'assets/images/chat-empty.png',
    'assets/images/user-empty.png',
    'assets/images/talk-empty.png',
    'assets/images/mine-empty.png',
  ];

  final List<String> name = [
    '消息',
    '通讯',
    '说说',
    '我的',
  ];

  void onTap(int index) {
    currentIndex = index;
    update([const Key("main")]);
  }
}
