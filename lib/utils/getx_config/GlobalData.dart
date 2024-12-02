import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/utils/app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends GetxController {
  final _userApi = UserApi();
  var unread = <String, int>{}.obs;
  var currentUserId = '';
  var currentUserAccount = '';

  Future<void> init() async {
    await onGetUserUnreadInfo();
    SharedPreferences.getInstance().then((prefs) {
      currentUserId = prefs.getString('userId') ?? '';
      currentUserAccount = prefs.getString('account') ?? '';
    });
  }

  Future<void> onGetUserUnreadInfo() async {
    final result = await _userApi.unread();
    if (result['code'] == 0) {
      unread.assignAll(Map<String, int>.from(result['data']));
      AppBadger.setCount(getUnreadCount('chat'), getUnreadCount('notify'));
    }
  }

  int getUnreadCount(String type) {
    if (unread.value.containsKey(type)) {
      return unread.value[type]!;
    }
    return 0;
  }
}
