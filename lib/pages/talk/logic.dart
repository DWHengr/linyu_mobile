import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/talk_api.dart';
import 'package:linyu_mobile/api/user_api.dart';

class TalkLogic extends GetxController {
  final _talkApi = TalkApi();
  final _userApi = UserApi();

  List<dynamic> talkList = [];
  int index = 0;
  bool hasMore = true;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  void init() {
    onTalkList();
    scrollController.addListener(scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      onTalkList();
    }
  }

  void onTalkList() {
    if (!hasMore || isLoading) return;
    isLoading = true;
    update([const Key("talk")]);
    _talkApi.list(index, 10).then((res) {
      if (res['code'] == 0) {
        final List<dynamic> newTalks = res['data'];
        if (newTalks.isEmpty) {
          hasMore = false;
        } else {
          talkList.addAll(newTalks);
          index += newTalks.length;
        }
        isLoading = false;
      } else {
        isLoading = false;
      }
    }).catchError(() {
      isLoading = false;
    }).whenComplete(() {
      update([const Key("talk")]);
    });
  }

  Future<void> refreshData() async {
    talkList.clear();
    index = 0;
    hasMore = true;
    update([const Key("talk")]);
    onTalkList();
  }

  Future<String> onGetImg(String fileName, String userId) async {
    dynamic res = await _userApi.getImg(fileName, userId);
    if (res['code'] == 0) {
      return res['data'];
    }
    return '';
  }
}
