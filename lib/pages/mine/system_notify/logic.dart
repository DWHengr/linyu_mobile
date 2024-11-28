import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:linyu_mobile/api/notify_api.dart';

class SystemNotifyLogic extends GetxController {
  final _notifyApi = NotifyApi();
  late List<dynamic> systemNotifyList = [];

  @override
  void onInit() {
    super.onInit();
    onGetSystemNotify();
  }

  void onGetSystemNotify() {
    _notifyApi.systemListNotify().then((res) {
      if (res['code'] == 0) {
        systemNotifyList = res['data'];
        update([const Key('system_notify')]);
      }
    });
  }
}
