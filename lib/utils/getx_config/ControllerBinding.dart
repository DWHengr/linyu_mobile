import 'package:get/get.dart';
import 'package:linyu_mobile/pages/add_friend/friend_info/logic.dart';
import 'package:linyu_mobile/pages/add_friend/friend_request/logic.dart';
import 'package:linyu_mobile/pages/add_friend/logic.dart';
import 'package:linyu_mobile/pages/chat_list/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_group/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_remark/logic.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/pages/login/logic.dart';
import 'package:linyu_mobile/pages/mine/about/logic.dart';
import 'package:linyu_mobile/pages/mine/logic.dart';
import 'package:linyu_mobile/pages/mine/mine_qr_code/logic.dart';
import 'package:linyu_mobile/pages/navigation/logic.dart';
import 'package:linyu_mobile/pages/password/retrieve/logic.dart';
import 'package:linyu_mobile/pages/password/update/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_friend_affirm/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_login_affirm/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_other_result/logic.dart';
import 'package:linyu_mobile/pages/register/logic.dart';
import 'package:linyu_mobile/pages/talk/logic.dart';
import 'package:linyu_mobile/pages/talk/talk_details/logic.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:linyu_mobile/pages/mine/edit/logic.dart';

//依赖注入
class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalThemeConfig(), permanent: true);
    Get.put(GlobalData(), permanent: true);
    Get.lazyPut(() => NavigationLogic());
    Get.lazyPut(() => LoginPageLogic());
    Get.lazyPut(() => RegisterPageLogic());
    Get.lazyPut(() => RetrievePasswordLogic());
    Get.lazyPut(() => UpdatePasswordLogic());
    Get.lazyPut(() => ChatListLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => TalkLogic());
    Get.lazyPut(() => QRCodeScanLogic());
    Get.lazyPut(() => QRLoginAffirmLogic());
    Get.lazyPut(() => EditMineLogic());
    Get.lazyPut(() => MineQRCodeLogic());
    Get.lazyPut(() => QRFriendAffirmLogic());
    Get.lazyPut(() => QrOtherResultLogic());
    Get.lazyPut(() => AboutLogic());
    Get.lazyPut(() => FriendInformationLogic());
    Get.lazyPut(() => SetRemarkLogic());
    Get.lazyPut(() => SetGroupLogic());
    Get.lazyPut(() => AddFriendLogic());
    Get.lazyPut(() => SearchInfoLogic());
    Get.lazyPut(() => FriendRequestLogic());
    Get.lazyPut(() => TalkDetailsLogic());
  }
}
