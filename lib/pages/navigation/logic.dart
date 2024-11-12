import 'package:get/get.dart';

class NavigationLogic extends GetxController {
  final currentIndex = 0.obs;

  final List<String> selectedIcons = [
    'assets/images/chat.png',
    'assets/images/user.png',
    'assets/images/talk.png',
    'assets/images/mine.png',
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
    currentIndex.value = index;
  }
}
