import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/friend_api.dart';

class UserSelectLogic extends GetxController {
  final _friendApi = FriendApi();
  late List<dynamic> userList = [];
  late List<dynamic> allUserList = [];
  late List<dynamic> selectedUsers = [];

  @override
  void onInit() {
    super.onInit();
    selectedUsers = Get.arguments['selectedUsers'].toList();
    update([const Key('user_select')]);
    loadUsers();
  }

  void loadUsers() async {
    _friendApi.listFlat().then((res) {
      if (res['code'] == 0) {
        userList = res['data'];
        allUserList = res['data'];
        update([const Key('user_select')]);
      }
    });
  }

  void handlerSelectUser(user) {
    if (selectedUsers
        .any((selected) => selected['friendId'] == user['friendId'])) {
      selectedUsers
          .removeWhere((selected) => selected['friendId'] == user['friendId']);
    } else {
      selectedUsers.add(user);
    }
    update([const Key('user_select')]);
  }

  void handlerSearchUser(String keyword) {
    if (keyword.isEmpty || keyword == '') {
      userList = allUserList;
    } else {
      userList = allUserList
          .where((user) =>
              (user['name']?.contains(keyword) ?? false) ||
              (user['remark']?.contains(keyword) ?? false))
          .toList();
    }
    update([const Key('user_select')]);
  }

  void handlerConfirmSelection() {
    Get.back(result: selectedUsers);
  }
}
