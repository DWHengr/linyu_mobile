import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/talk_api.dart';
import 'package:linyu_mobile/api/talk_comment_api.dart';
import 'package:linyu_mobile/api/talk_like_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/talk/logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TalkDetailsLogic extends GetxController {
  final _talkApi = TalkApi();
  final _talkLikeApi = TalkLikeApi();
  final _talkCommentApi = TalkCommentApi();
  late String talkId = '';
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();
  late dynamic talkDetails = {
    'userId': '',
    'name': '',
    'portrait': '',
    'remark': '',
    'talkId': '',
    'content': {},
    'latestComment': [],
    'time': '',
    'likeNum': 0,
    'commentNum': 0,
  };
  String currentUserId = '';
  List<dynamic> talkLikeList = [];
  List<dynamic> talkCommentList = [];
  late bool isLiked = false;
  final TalkLogic _talkLogic = Get.find<TalkLogic>();

  @override
  void onInit() {
    SharedPreferences.getInstance().then((prefs) {
      currentUserId = prefs.getString('userId') ?? '';
    });
    talkId = Get.arguments['talkId'];
    _onGetTalkDetails();
    _onGetTalkLikeList();
    _onGetTalkCommentList();
  }

  void _onGetTalkDetails() {
    _talkApi.details(talkId).then((res) {
      if (res['code'] == 0) {
        talkDetails = res['data'];
        update([const Key('talk_details')]);
      }
    });
  }

  void _onGetTalkLikeList() {
    _talkLikeApi.list(talkId).then((res) {
      if (res['code'] == 0) {
        talkLikeList = res['data'];
        for (var item in talkLikeList) {
          if (item['userId'] == currentUserId) {
            isLiked = true;
            break;
          }
        }
        if (talkLikeList.length != talkDetails['likeNum']) {
          _talkLogic.updateTalkLikeOrCommentCount(
              'likeNum', talkLikeList.length, talkId);
        }
        update([const Key('talk_details')]);
      }
    });
  }

  void onCreateOrDeleteTalkLike() async {
    if (isLiked) {
      await _talkLikeApi.delete(talkId);
    } else {
      await _talkLikeApi.create(talkId);
    }
    isLiked = !isLiked;
    update([const Key('talk_details')]);
    _onGetTalkLikeList();
  }

  void _onGetTalkCommentList() {
    _talkCommentApi.list(talkId).then((res) {
      if (res['code'] == 0) {
        talkCommentList = res['data'];
        if (talkCommentList.length != talkDetails['commentNum']) {
          _talkLogic.updateTalkLikeOrCommentCount(
              'commentNum', talkCommentList.length, talkId);
        }
        update([const Key('talk_details')]);
      }
    });
  }

  void onDeleteTalkComment(talkCommentId) {
    _talkCommentApi.delete(talkId, talkCommentId).then((res) {
      if (res['code'] == 0) {
        CustomFlutterToast.showSuccessToast('评论删除成功~');
        _onGetTalkCommentList();
        update([const Key('talk_details')]);
      }
    });
  }

  void onCreateTalkComment() {
    if (commentController.text == '') {
      return;
    }
    _talkCommentApi.create(talkId, commentController.text).then((res) {
      if (res['code'] == 0) {
        commentController.text = '';
        CustomFlutterToast.showSuccessToast('评论成功~');
        _onGetTalkCommentList();
        update([const Key('talk_details')]);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
    commentFocusNode.dispose();
  }
}
