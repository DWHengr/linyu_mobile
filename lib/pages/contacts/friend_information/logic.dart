import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FriendInformationLogic extends Logic {


  //评论输入框焦点
  final FocusNode commentFocus = new FocusNode();

  //评论输入框控制器
  final TextEditingController commentController = TextEditingController();

  //主题配置
  final GlobalThemeConfig _theme = GetInstance().find<GlobalThemeConfig>();

  //联系人逻辑
  final ContactsLogic _contactsLogic = GetInstance().find<ContactsLogic>();

  //好友api
  final _friendApi = FriendApi();

  //用户api
  final _userApi = UserApi();

  //透明度
  RxDouble opacity = 0.0.obs;

  //滚动控制器
  final scrollController = ScrollController();

  //初始化获取从联系人页面传递过来的好友信息参数
  Map<String, dynamic> get friendData => arguments['friend'];

  //初始化获取从联系人页面传递过来的分组列表参数
  List<Map<String, dynamic>> get groupList => arguments['groupList'];

  //好友id
  String get friendId => friendData['friendId'].toString();

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
  String get friendRemark => _friendRemark;
  set friendRemark(String value) {
    _friendRemark = value;
    update([const Key('friend_info')]);
  }

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
  Future<Map<String, dynamic>> _getFriendInfo() async {
    final response = await _friendApi.details(friendId);
    if (response['code'] == 0) {
      final data = response['data'];
      talkContent = data['talkContent'] ?? talkContent;
      friendPortrait = data['portrait'];
      friendName = data['name'];
      friendRemark = data['remark'] ?? '';
      friendAccount = data['account'];
      friendGender = data['sex'];
      final birthday =
          DateTime.parse(data['birthday'] ?? DateTime.now().toString());
      //计算年龄
      friendAge = DateTime.now().difference(birthday).inDays ~/ 365;
      friendBirthday = "${birthday.month}月${birthday.day}日";
      friendSignature = data['signature'];
      isConcern = data['isConcern'];
    }
    return response['data'];
  }

  //获取好友说说图片
  Future<String> getImg(String fileName, String userId) async {
    dynamic res = await _userApi.getImg(fileName, userId);
    if (res['code'] == 0) {
      return res['data'];
    }
    return '';
  }

  //设置分组
  void setGroup(String value) async {
    if (value == '0') {
      Fluttertoast.showToast(
          msg: "选择有误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    friendGroup = value;
    final response = await _friendApi.setGroup(friendId, friendGroup);
    print(response);
    if (response['code'] == 0) {
      Fluttertoast.showToast(
          msg: "修改分组成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: _theme.primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    print('选中的value是：$friendGroup');
  }

  //设置备注
  void setRemark(String value, BuildContext context) async {
    print(value);
    commentFocus.unfocus();
    FocusScope.of(context).requestFocus(new FocusNode());
    if (value.isEmpty || friendRemark == value) {
      return;
    }
    final response = await _friendApi.setRemark(friendId, value);
    if (response['code'] == 0) {
      friendRemark = value;
    } else {
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //设置特别关心
  void setConcern() async {
    if(isConcern){
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
      Fluttertoast.showToast(
          msg: "设置成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: _theme.primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      isConcern = !isConcern;
    } else {
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //删除好友
  void deleteFriend() async {
    final response = await _friendApi.delete(friendId);
    if (response['code'] == 0) {
      Fluttertoast.showToast(
          msg: "删除成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: _theme.primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.back();
    } else {
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //滚动监听
  void scrollListener() {
    if (scrollController.offset > 140 &&
        !scrollController.position.outOfRange &&
        opacity.value != 1) opacity.value = 1;

    if (scrollController.offset < 140 &&
        !scrollController.position.outOfRange &&
        opacity.value != 0) opacity.value = 0;
  }

  @override
  onInit() {
    super.onInit();
    scrollController.addListener(scrollListener);
    friendGroup = friendData['groupId']?? '0';
  }

  @override
  void onReady() {
    super.onReady();
    _getFriendInfo();
  }

  @override
  void onClose() {
    super.onClose();
    _contactsLogic.init();
  }
}
