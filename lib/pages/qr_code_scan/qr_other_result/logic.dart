import 'package:get/get.dart';

class QrOtherResultLogic extends GetxController {
  late String text;

  @override
  void onInit() {
    text = Get.arguments['text'];
  }
}
