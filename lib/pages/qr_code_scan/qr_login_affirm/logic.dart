import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';

class QRLoginAffirmLogic extends GetxController {
  final _userAPi = UserApi();
  late final String qrCode;

  @override
  void onInit() {
    qrCode = Get.arguments['qrCode'];
  }

  void onQrLogin() {
    _userAPi.qrLogin(qrCode).then((res) {
      if (res['code'] == 0) {
        CustomFlutterToast.showSuccessToast("登录成功~");
        Get.offAllNamed('/');
      }
    });
  }
}
