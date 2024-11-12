import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';

class ChatListLogic extends GetxController {
  final _chatListApi = ChatListApi();
  final _friendApi = FriendApi();
  late List<dynamic> topList = [];
  late List<dynamic> otherList = [];
  late List<dynamic> searchList = [];

  void onGetChatList() {
    _chatListApi.list().then((res) {
      if (res['code'] == 0) {
        topList = res['data']['tops'];
        otherList = res['data']['others'];
        update();
      }
    });
  }

  void onTopStatus(String id, bool isTop) {
    _chatListApi.top(id, !isTop).then((res) {
      if (res['code'] == 0) {
        onGetChatList();
      }
    });
  }

  void onDeleteChatList(String id) {
    _chatListApi.delete(id).then((res) {
      if (res['code'] == 0) {
        onGetChatList();
      }
    });
  }

  void onSearchFriend(String friendInfo) {
    if (friendInfo == null || friendInfo.trim() == '') {
      searchList = [];
      searchList = [];
      update();
      return;
    }
    _friendApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        searchList = res['data'];
        update();
      }
    });
  }
}
