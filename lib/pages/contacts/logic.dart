import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsLogic extends GetxController {
  final _friendApi = FriendApi();
  final _chatGroupApi = ChatGroupApi();
  final _notifyApi = NotifyApi();
  List<String> tabs = ['我的群聊', '我的好友', '好友通知'];
  int selectedIndex = 1;
  String currentUserId = '';
  List<dynamic> friendList = [];
  List<dynamic> chatGroupList = [];
  List<dynamic> notifyFriendList = [];

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      currentUserId = prefs.getString('userId') ?? '';
      update();
    });
    onNotifyFriendList();
    onChatGroupList();
    onFriendList();
  }

  void onFriendList() {
    _friendApi.list().then((res) {
      if (res['code'] == 0) {
        friendList = res['data'];
        update();
      }
    });
  }

  void onChatGroupList() {
    _chatGroupApi.list().then((res) {
      if (res['code'] == 0) {
        chatGroupList = res['data'];
        update();
      }
    });
  }

  void onNotifyFriendList() {
    _notifyApi.friendList().then((res) {
      if (res['code'] == 0) {
        notifyFriendList = res['data'];
        update();
      }
    });
  }

  void handlerTabTapped(int index) {
    selectedIndex = index;
    update();
  }
}
