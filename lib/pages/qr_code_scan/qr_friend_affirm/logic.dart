import 'package:get/get.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class QRFriendAffirmLogic extends GetxController {
  final _notifyApi = NotifyApi();
  late final dynamic result;

  @override
  void onInit() {
    super.onInit();
    result = Get.arguments['result'];
  }

  void onAddFriend() {
    _notifyApi.friendApply(result['id'], "通过二维码添加好友").then((res) {
      if (res['code'] == 0) {
        CustomFlutterToast.showSuccessToast("请求成功");
      }
      // Get.until((route) => Get.currentRoute == "/");
    });
  }
}
