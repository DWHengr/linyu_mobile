import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class SearchInfoLogic extends Logic {
  //搜索结果
  dynamic get _friendInfo => arguments['friend'];

  //好友头像
  String _friendPortrait = '';

  String get friendPortrait => _friendPortrait;

  set friendPortrait(String value) {
    _friendPortrait = value;
    update([const Key('search_info')]);
  }

  //好友昵称
  String _friendName = '';

  String get friendName => _friendName;

  set friendName(String value) {
    _friendName = value;
    update([const Key('search_info')]);
  }

  //好友账号
  String _friendAccount = '';

  String get friendAccount => _friendAccount;

  set friendAccount(String value) {
    _friendAccount = value;
    update([const Key('friend_info')]);
  }

  //好友签名
  String _friendSignature = '';

  String get friendSignature => _friendSignature;

  set friendSignature(String value) {
    _friendSignature = value;
    update([const Key('search_info')]);
  }

  //好友性别
  String _friendSex = '';

  String get friendSex => _friendSex;

  set friendSex(String value) {
    _friendSex = value;
    update([const Key('friend_info')]);
  }

  //好友生日
  String _friendBirthday = '';

  String get friendBirthday => _friendBirthday;

  set friendBirthday(String value) {
    _friendBirthday = value;
    update([const Key('search_info')]);
  }

  //邮箱
  String _friendEmail = '';

  String get friendEmail => _friendEmail;

  set friendEmail(String value) {
    _friendEmail = value;
    update([const Key('search_info')]);
  }

  void initData() {
    friendPortrait = _friendInfo['portrait'];
    friendName = _friendInfo['name'];
    friendAccount = _friendInfo['account'];
    friendSignature = _friendInfo['signature'] ?? '';
    friendSex = _friendInfo['sex'];
    friendBirthday = _friendInfo['birthday'];
  }

  //进入好友申请页面
  void goApplyFriend() =>
      Get.toNamed('/friend_request', arguments: {'friendInfo': _friendInfo});

  @override
  void onInit() {
    super.onInit();
    initData();
  }
}
