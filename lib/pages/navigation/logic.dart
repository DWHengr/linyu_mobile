import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:linyu_mobile/utils/notification.dart';
import 'package:linyu_mobile/utils/permission_handler.dart';
import 'package:linyu_mobile/utils/web_socket.dart';

class NavigationLogic extends GetxController {
  late RxInt currentIndex = 0.obs;
  final _wsManager = WebSocketUtil();
  StreamSubscription? _subscription;

  GlobalData get globalData => GetInstance().find<GlobalData>();

  Future<void> initThemeData() async {
    late String sex = Get.parameters['sex'] ?? "男";
    GlobalThemeConfig theme = GetInstance().find<GlobalThemeConfig>();
    theme.changeThemeMode(sex == "女" ? 'pink' : 'blue');
  }

  @override
  void onInit() {
    super.onInit();
    (() async {
      await globalData.init();
      await NotificationUtil.initialize();
      await NotificationUtil.createNotificationChannel();
      await PermissionHandler.permissionRequest();
      await connectWebSocket();
      eventListen();
    })();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initThemeData();
    });
  }

  void eventListen() {
    // 监听消息
    _subscription = _wsManager.eventStream.listen((event) {
      globalData.onGetUserUnreadInfo();
      if (event['type'] == 'on-receive-video') {
        var data = event['content'];
        if (data['type'] == "invite") {
          Get.toNamed('/video_chat', arguments: {
            'userId': data['fromId'],
            'isSender': false,
            'isOnlyAudio': data['isOnlyAudio'],
          });
        }
      }
    });
  }

  Future<void> connectWebSocket() async {
    _wsManager.connect();
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

  @override
  void onClose() {
    super.onClose();
    _wsManager.dispose();
    _subscription?.cancel();
  }
}
