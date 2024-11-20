import 'package:app_badge_plus/app_badge_plus.dart';

class AppBadger {
  static int _chatCount = 0;
  static int _notifyCount = 0;

  static void setCount(int chatCount, int notifyCount) {
    _chatCount = chatCount;
    _notifyCount = notifyCount;
    _updateBadgeCount();
  }

  static void setChatCount(int count) {
    _chatCount = count;
    _updateBadgeCount();
  }

  static void setNotifyCount(int count) {
    _notifyCount = count;
    _updateBadgeCount();
  }

  static void _updateBadgeCount() async {
    if (await AppBadgePlus.isSupported()) {
      if (_chatCount + _notifyCount > 0) {
        await AppBadgePlus.updateBadge(_chatCount + _notifyCount);
      } else {
        _notifyCount = 0;
        _chatCount = 0;
        await AppBadgePlus.updateBadge(0);
      }
    }
  }
}
