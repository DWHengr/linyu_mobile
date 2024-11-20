import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/app_badger.dart';

class GlobalData extends GetxController {
  final _userApi = UserApi();
  late Map<String, dynamic> unread;

  void init() {
    _onGetUserUnreadInfo();
  }

  void _onGetUserUnreadInfo() async {
    final result = await _userApi.unread();
    if (result['code'] == 0) {
      unread = result['data'];
      AppBadger.setCount(getUnreadCount('chat'), getUnreadCount('notify'));
      update();
    }
  }

  int getUnreadCount(String type) {
    if (unread.containsKey(type)) {
      return unread[type];
    }
    return 0;
  }
}
