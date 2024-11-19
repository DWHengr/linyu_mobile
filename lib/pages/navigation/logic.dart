import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:linyu_mobile/utils/web_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationLogic extends GetxController {
  late int currentIndex = 0;
  final _wsManager = WebSocketUtil();

  void initData() {
    late String sex = Get.parameters['sex'] ?? "男";
    GlobalThemeConfig theme = GetInstance().find<GlobalThemeConfig>();
    theme.changeThemeMode(sex == "女" ? 'pink' : 'blue');
  }

  @override
  void onInit() {
    super.onInit();
    initData();
    connectWebSocket();
  }

  void connectWebSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-token');
    _wsManager.connect(token!);
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

  @override
  void onClose() {
    super.onClose();
  }
}
