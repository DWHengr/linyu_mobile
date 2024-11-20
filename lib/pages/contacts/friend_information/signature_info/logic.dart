import 'package:get/get.dart';

class SignatureInfoLogic extends GetxController {
  final signature = ''.obs;

  @override
  void onInit() {
    super.onInit();
    signature.value = Get.arguments['signature'];
  }
}
