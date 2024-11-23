import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/talk_api.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TalkLogic extends GetxController {
  final _talkApi = TalkApi();
  final _userApi = UserApi();
  String currentUserId = '';

  List<dynamic> talkList = [];
  int index = 0;
  bool hasMore = true;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  void init() async {
    onTalkList();
    scrollController.addListener(scrollListener);
    SharedPreferences.getInstance().then((prefs) {
      currentUserId = prefs.getString('userId') ?? '';
    });
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

  void updateTalkLikeOrCommentCount(String key, int num, String talkId) {
    for (var talk in talkList) {
      if (talk['talkId'] == talkId) {
        talk[key] = num;
        update([const Key("talk")]);
        return;
      }
    }
  }

  void onDeleteTalk(talkId) {
    _talkApi.delete(talkId).then((res) {
      if (res['code'] == 0) {
        for (var talk in talkList) {
          if (talk['talkId'] == talkId) {
            talkList.remove(talk);
            update([const Key("talk")]);
            return;
          }
        }
      }
    });
  }

  void handlerDeleteTalkTip(BuildContext context, String talkId) {
    CustomDialog.showTipDialog(
      context,
      text: '确认删除该条说说?',
      onOk: () => onDeleteTalk(talkId),
      onCancel: () {},
    );
  }

  Future<String> onGetImg(String fileName, String userId) async {
    dynamic res = await _userApi.getImg(fileName, userId);
    if (res['code'] == 0) {
      return res['data'];
    }
    return '';
  }
}
