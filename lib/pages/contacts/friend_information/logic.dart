import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/video_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FriendInformationLogic extends Logic {
  //联系人逻辑
  final ContactsLogic _contactsLogic = GetInstance().find<ContactsLogic>();

  //后端api
  final _friendApi = new FriendApi();
  final _videoApi = new VideoApi();
  final _chatListApi = new ChatListApi();

  //初始化获取从联系人页面传递过来的好友信息参数
  Map<String, dynamic> get friendData => arguments['friend'];

  //好友id
  final String friendId = Get.arguments['friendId'].toString();

  //好友头像
  String _friendPortrait = '';

  String get friendPortrait => _friendPortrait;

  set friendPortrait(String value) {
    _friendPortrait = value;
    update([const Key('friend_info')]);
  }

  //好友昵称
  String _friendName = '';

  String get friendName => _friendName;

  set friendName(String value) {
    _friendName = value;
    update([const Key('friend_info')]);
  }

  //好友备注
  String _friendRemark = '';

  set friendRemark(String value) {
    _friendRemark = value;
    update([const Key('friend_info')]);
  }

  String get friendRemark => _friendRemark;

  //好友账号
  String _friendAccount = '';

  String get friendAccount => _friendAccount;

  set friendAccount(String value) {
    _friendAccount = value;
    update([const Key('friend_info')]);
  }

  //好友性别
  String _friendGender = '';

  String get friendGender => _friendGender;

  set friendGender(String value) {
    _friendGender = value;
    update([const Key('friend_info')]);
  }

  //好友年龄
  int _friendAge = 0;

  int get friendAge => _friendAge;

  set friendAge(int value) {
    _friendAge = value;
    update([const Key('friend_info')]);
  }

  //好友生日
  String _friendBirthday = '';

  String get friendBirthday => _friendBirthday;

  set friendBirthday(String value) {
    _friendBirthday = value;
    update([const Key('friend_info')]);
  }

  //好友分组
  String _friendGroup = '';

  String get friendGroup => _friendGroup;

  set friendGroup(String value) {
    _friendGroup = value;
    update([const Key('friend_info')]);
  }

  //好友签名
  String _friendSignature = '';

  String get friendSignature => _friendSignature;

  set friendSignature(String value) {
    _friendSignature = value;
    update([const Key('friend_info')]);
  }

  //特别关心
  bool _isConcern = false;

  bool get isConcern => _isConcern;

  set isConcern(bool value) {
    _isConcern = value;
    update([const Key('friend_info')]);
  }

  //好友说说
  Map<String, dynamic> _talkContent = {
    "text": "",
    "img": [],
  };

  Map<String, dynamic> get talkContent => _talkContent;

  set talkContent(Map<String, dynamic> value) {
    _talkContent = value;
    update([const Key('friend_info')]);
  }

  //获取好友信息
  Future<Map<String, dynamic>> getFriendInfo() async {
    if (friendId != '0') {
      final response = await _friendApi.details(friendId);
      if (response['code'] == 0) {
        final data = response['data'];
        talkContent = data['talkContent'] ?? talkContent;
        friendPortrait = data['portrait'];
        friendName = data['name'];
        friendRemark = data['remark'] ?? '';
        friendAccount = data['account'];
        friendGender = data['sex'];
        friendBirthday = data['birthday'];
        friendSignature = data['signature'] ?? '';
        friendGroup = data['groupName'] ?? '未分组';
        isConcern = data['isConcern'];
      }
      update([const Key('friend_info')]);
      return response['data'];
    } else {
      return {};
    }
  }

  //设置特别关心
  void setConcern() async {
    if (isConcern) {
      final response = await _friendApi.unCareFor(friendId);
      setResult(response);
      return;
    }
    final response = await _friendApi.careFor(friendId);
    setResult(response);
  }

  //特别关心结果
  void setResult(Map<String, dynamic> response) {
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast(isConcern ? "已取消特别关心~" : "特别关心成功~");
      isConcern = !isConcern;
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  //删除好友
  void deleteFriend() async {
    final response = await _friendApi.delete(friendId);
    if (response['code'] == 0) {
      CustomFlutterToast.showSuccessToast("删除成功~");
      Get.back();
    } else {
      CustomFlutterToast.showErrorToast(response['msg']);
    }
  }

  void onVideoChat({bool isOnlyAudio = false}) =>
      _videoApi.invite(friendId, isOnlyAudio).then((res) {
        if (res['code'] == 0) {
          Get.toNamed('video_chat', arguments: {
            'userId': friendId,
            'isSender': true,
            'isOnlyAudio': isOnlyAudio,
          });
        }
      });

  void onToSendMsg() => _chatListApi.createChat(friendId, type: 'user').then((res) {
    if (res['code'] == 0) {
      Get.offAndToNamed('/chat_frame', arguments: {
        'chatInfo': res['data'],
      });
    }
  });

  @override
  void onInit() {
    super.onInit();
    getFriendInfo();
  }

  @override
  void onClose() {
    super.onClose();
    _contactsLogic.init();
  }
}
