import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_instance/src/get_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/pages/mine/logic.dart';
import 'package:linyu_mobile/utils/cropPicture.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' show MultipartFile, FormData;

//个人资料编辑页面逻辑
class EditMineLogic extends getx.GetxController {
  //上个页面控制器
  final MineLogic _mineLogic = getx.Get.find<MineLogic>();

  //用户API
  final _useApi = UserApi();

  //用户名输入框控制器
  final TextEditingController nameController = new TextEditingController();

  //签名输入框控制器
  final TextEditingController signatureController = new TextEditingController();

  //签名输入框控制器
  final TextEditingController birthdayController = new TextEditingController();

  //当前用户信息
  late dynamic currentUserInfo = {};

  //是否处于编辑状态
  bool _isEdit = false;

  bool get isEdit => _isEdit;

  set isEdit(bool value) {
    _isEdit = value;
    update([const Key("edit_mine")]);
  }

  //用户名输入长度
  int _nameTextLength = 0;

  int get nameTextLength => _nameTextLength;

  set nameTextLength(int value) {
    _nameTextLength = value;
    update([const Key("login")]);
  }

  //性别
  late String _sex;

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
    update([const Key("edit_mine")]);
  }

  //男性颜色被选中时的颜色
  Color _maleColorActive = const Color(0xFFe0e0e0);

  Color get maleColorActive => _maleColorActive;

  set maleColorActive(Color value) {
    _maleColorActive = value;
    update([const Key("edit_mine")]);
  }

  //男性文字颜色被选中时的颜色
  Color _maleTextColorActive = const Color(0xFF727275);

  Color get maleTextColorActive => _maleTextColorActive;

  set maleTextColorActive(Color value) {
    _maleTextColorActive = value;
    update([const Key("edit_mine")]);
  }

  //女性颜色被选中时的颜色
  Color _femaleColorActive = const Color(0xFFe0e0e0);

  Color get femaleColorActive => _femaleColorActive;

  set femaleColorActive(Color value) {
    _femaleColorActive = value;
    update([const Key("edit_mine")]);
  }

  //女性文字颜色被选中时的颜色
  Color _femaleTextColorActive = const Color(0xFF727275);

  Color get femaleTextColorActive => _femaleTextColorActive;

  set femaleTextColorActive(Color value) {
    _femaleTextColorActive = value;
    update([const Key("edit_mine")]);
  }

  //生日
  late DateTime _birthday;

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
    update([const Key("edit_mine")]);
  }

  //个性签名输入长度
  int _signatureTextLength = 0;

  int get signatureTextLength => _signatureTextLength;

  set signatureTextLength(int value) {
    _signatureTextLength = value;
    update([const Key("edit_mine")]);
  }

  //上传头像
  void _uploadPicture(File picture) async {
    Map<String, dynamic> map = {};
    final file = await MultipartFile.fromFile(picture.path,
        filename: picture.path.split('/').last);
    map['type'] = 'image/jpeg';
    map['name'] = picture.path.split('/').last;
    map['size'] = picture.lengthSync();
    map["file"] = file;
    FormData formData = FormData.fromMap(map);
    final result = await _useApi.upload(formData);
    if (result['code'] == 0) {
      Fluttertoast.showToast(
          msg: "头像修改成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFF4C9BFF),
          textColor: Colors.white,
          fontSize: 16.0);
      currentUserInfo['portrait'] = result['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('portrait', currentUserInfo['portrait']);
      update([const Key("edit_mine")]);
    } else {
      Fluttertoast.showToast(
          msg: result['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  ///裁剪图片
  Future _cropChatBackgroundPicture(ImageSource? type) async =>
      cropPicture(type, _uploadPicture);

  //点击头像按钮弹出底部选择框
  void selectPortrait(BuildContext context) {
    if (!isEdit) return;
    getx.Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: Colors.white60,
      ),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("图库"),
            onTap: () =>
                //改变主题模式(白天模式还是夜晚模式)
                //Get.isDarkMode用来判断是否是夜晚模式
                _cropChatBackgroundPicture(null),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("拍照"),
            onTap: () =>
                //改变主题模式(白天模式还是夜晚模式)
                _cropChatBackgroundPicture(ImageSource.camera),
          )
        ],
      ),
    ));
  }

  //设置性别值
  void setSexValue(String value) {
    sex = value;
    if (value == "男") {
      maleColorActive = const Color(0xFF4C9BFF);
      maleTextColorActive = Colors.white;
      femaleColorActive = const Color(0xFFe0e0e0);
      femaleTextColorActive = const Color(0xFF727275);
    } else {
      maleColorActive = const Color(0xFFe0e0e0);
      maleTextColorActive = const Color(0xFF727275);
      femaleColorActive = const Color(0xFFffa0cf);
      femaleTextColorActive = Colors.white;
    }
  }

  //设置性别
  void setSex(String value) {
    if (isEdit) {
      setSexValue(value);
    }
    return;
  }

  //用户账号输入长度
  void onNameTextChanged(String value) {
    nameTextLength = value.length;
    if (nameTextLength >= 30) nameTextLength = 30;
  }

  //个性签名输入长度
  void onSignatureTextChanged(String value) {
    signatureTextLength = value.length;
    if (signatureTextLength >= 100) signatureTextLength = 100;
  }

  //选择生日
  Future<void> selectDate(BuildContext context) async {
    if (isEdit) {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: birthday,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != birthday) {
        birthday = pickedDate;
        birthdayController.text =
            DateFormat('yyyy-MM-dd').format(birthday); // 格式化日期
      }
    }
  }

  //点击保存按钮进行网络请求
  void onPressed() async {
    if (!isEdit) {
      isEdit = true;
      return;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String name = nameController.text;
      String signature = signatureController.text;
      String birthday = this.birthday.toString();
      String portrait = currentUserInfo['portrait'];
      final updateResult = await _useApi.update(
          name: name,
          sex: sex,
          birthday: birthday,
          signature: signature,
          portrait: portrait);
      if (updateResult['code'] == 0) {
        Fluttertoast.showToast(
            msg: "资料修改成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF4C9BFF),
            textColor: Colors.white,
            fontSize: 16.0);
        prefs.setString('username', name);
        prefs.setString('portrait', portrait);
        prefs.setString('sex', sex);
        prefs.setString('birthday', birthday);
        prefs.setString('signature', signature);
        GlobalThemeConfig theme = GetInstance().find<GlobalThemeConfig>();
        theme.changeThemeMode(sex == "女" ? "pink" : "blue");
        isEdit = false;
        return;
      } else {
        Fluttertoast.showToast(
            msg: updateResult['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return;
    }
  }

  //初始化
  @override
  void onInit() async {
    super.onInit();
    final userInfo = await _useApi.info();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserInfo['name'] =
        prefs.getString('username') ?? userInfo['data']['name'];
    currentUserInfo['portrait'] =
        prefs.getString('portrait') ?? userInfo['data']['portrait'];
    nameController.text = currentUserInfo['name'];
    nameTextLength = nameController.text.length;
    sex = prefs.getString('sex') ?? userInfo['data']['sex'];
    setSexValue(sex);
    currentUserInfo['sex'] = sex;
    birthday = DateTime.parse(userInfo['data']['birthday']).toLocal();
    birthdayController.text =
        DateFormat('yyyy-MM-dd').format(birthday); // 格式化日期
    currentUserInfo['birthday'] = birthday;
    signatureController.text =
        prefs.getString('signature') ?? userInfo['data']['signature'];
    signatureTextLength = signatureController.text.length;
  }

  //当页面返回时，销毁控制器
  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    signatureController.dispose();
    birthdayController.dispose();
    //以及返回上一页时更新页面
    _mineLogic.init();
  }
}
