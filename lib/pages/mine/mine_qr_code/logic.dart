import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/qr_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MineQRCodeLogic extends GetxController {
  final _qrApi = QrApi();
  late dynamic currentUserInfo = {};
  late String qrCode = '';

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserInfo['name'] = prefs.getString('username');
    currentUserInfo['portrait'] = prefs.getString('portrait');
    currentUserInfo['account'] = prefs.getString('account');
    currentUserInfo['sex'] = prefs.getString('sex');
    update([const Key("mine_qr_code")]);
    onQrCode();
  }

  void onQrCode() {
    _qrApi.code().then((res) {
      if (res['code'] == 0) {
        qrCode = res['data'];
        update([const Key("mine_qr_code")]);
      }
    });
  }
}
