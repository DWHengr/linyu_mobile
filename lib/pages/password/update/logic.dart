import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

import 'package:linyu_mobile/utils/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

//密码修改逻辑，页面逻辑与业务逻辑分离，可维护性高
//获取输入框内容，判断输入框内容是否为空，判断密码长度是否符合要求，两次输入的密码是否相同，网络请求修改密码，清除本地缓存，跳转到登录页面
class UpdatePasswordLogic extends GetxController {
  //用户API 进行网络请求
  final _useApi = UserApi();

  //密码输入框控制器
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //两次输入的密码是否相同
  bool _isConfirmEqualNew = false;

  bool get isConfirmEqualNew => _isConfirmEqualNew;

  set isConfirmEqualNew(bool value) {
    _isConfirmEqualNew = value;
    update([const Key("update_password")]);
  }

  //原密码输入长度
  int _oldPasswordTextLength = 0;

  int get oldPasswordTextLength => _oldPasswordTextLength;

  set oldPasswordTextLength(int value) {
    _oldPasswordTextLength = value;
    update([const Key("update_password")]);
  }

  //新密码输入长度
  int _newPasswordTextLength = 0;

  int get newPasswordTextLength => _newPasswordTextLength;

  set newPasswordTextLength(int value) {
    _newPasswordTextLength = value;
    update([const Key("update_password")]);
  }

  //确认密码输入长度
  //当密码输入框内容发生变化时会触发widget更新
  int _confirmPasswordTextLength = 0;

  int get confirmPasswordTextLength => _confirmPasswordTextLength;

  set confirmPasswordTextLength(int value) {
    _confirmPasswordTextLength = value;
    update([const Key("update_password")]);
  }

  //原密码输入长度更新
  void onOldPasswordTextChanged(String value) {
    oldPasswordTextLength = value.length;
    if (oldPasswordTextLength >= 16) oldPasswordTextLength = 16;
  }

  //新密码输入长度更新
  void onNewPasswordTextChanged(String value) {
    newPasswordTextLength = value.length;
    if (newPasswordTextLength >= 16) newPasswordTextLength = 16;
    isConfirmEqualNew =
        (newPasswordController.text == confirmPasswordController.text);
  }

  //确认密码输入长度更新
  void onConfirmPasswordTextChanged(String value) async {
    confirmPasswordTextLength = value.length;
    if (confirmPasswordTextLength >= 16) confirmPasswordTextLength = 16;
    isConfirmEqualNew =
        (newPasswordController.text == confirmPasswordController.text);
  }

  //提交按钮点击事件
  void onSubmit() async {
    //获取输入框内容
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    //判断输入框内容是否为空
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      CustomFlutterToast.showSuccessToast("请填写所有内容");
      return;
    } else if (!isConfirmEqualNew) {
      //两次输入的密码不一致
      return;
    } else {
      //判断密码长度是否符合要求
      if (confirmPassword.length < 6) {
        CustomFlutterToast.showErrorToast("原密码长度必须在6-16位之间");
        return;
      }
      //wait 等待加密
      String confirmPassEncrypt = await passwordEncrypt(confirmPassword);
      //网络请求修改密码
      var updatePasswordResult = await _useApi.updatePassword(
          oldPassword, newPassword, confirmPassEncrypt);
      //判断网络请求结果
      if (updatePasswordResult['code'] == 0) {
        CustomFlutterToast.showSuccessToast("密码修改成功,请重新登录!");
        //清除本地缓存
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        //跳转到登录页面
        Get.offAllNamed("/login");
      } else {
        CustomFlutterToast.showErrorToast(updatePasswordResult['msg']);
      }
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
