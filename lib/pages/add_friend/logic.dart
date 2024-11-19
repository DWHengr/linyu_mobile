import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/pages/navigation/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class AddFriendLogic extends Logic {
  final _userApi = new UserApi();

  final NavigationLogic _navigationLogic = Get.find<NavigationLogic>();

  late List<dynamic> searchList = [];

  void onSearchFriend(String friendInfo) {
    if (friendInfo.trim() == '') {
      searchList = [];
      searchList = [];
      update([const Key("add_friend")]);
      return;
    }
    _userApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        searchList = res['data'];
        update([const Key("add_friend")]);
      }
    });
  }

  // 进入好友详情页
  void toFriendDetail(dynamic friend) =>
      Get.toNamed("/search_info", arguments: {"friend": friend});

  // 申请加好友
  void goApplyFriend(dynamic friend) =>
      Get.toNamed('/friend_request', arguments: {'friendInfo': friend});

  @override
  void onClose() {
    super.onClose();
    _navigationLogic.initData();
  }
}
