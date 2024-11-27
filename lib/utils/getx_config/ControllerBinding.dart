import 'package:get/get.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/add_chat_group_notice/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_nickname/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_name/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_remark/logic.dart';
import 'package:linyu_mobile/pages/image_viewer/image_viewer_update/logic.dart';
import 'package:linyu_mobile/pages/image_viewer/logic.dart';
import 'package:linyu_mobile/pages/add_friend/friend_info/logic.dart';
import 'package:linyu_mobile/pages/add_friend/friend_request/logic.dart';
import 'package:linyu_mobile/pages/add_friend/logic.dart';
import 'package:linyu_mobile/pages/chat_list/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_group/logic.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_remark/logic.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/pages/contacts/user_select/logic.dart';
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
import 'package:linyu_mobile/pages/talk/talk_create/logic.dart';
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
    Get.lazyPut(() => NavigationLogic(),fenix: true);
    Get.lazyPut(() => LoginPageLogic(),fenix: true);
    Get.lazyPut(() => RegisterPageLogic(),fenix: true);
    Get.lazyPut(() => RetrievePasswordLogic(),fenix: true);
    Get.lazyPut(() => UpdatePasswordLogic(),fenix: true);
    Get.lazyPut(() => ChatListLogic(),fenix: true);
    Get.lazyPut(() => ContactsLogic(),fenix: true);
    Get.lazyPut(() => MineLogic(),fenix: true);
    Get.lazyPut(() => TalkLogic(),fenix: true);
    Get.lazyPut(() => QRCodeScanLogic(),fenix: true);
    Get.lazyPut(() => QRLoginAffirmLogic(),fenix: true);
    Get.lazyPut(() => EditMineLogic(),fenix: true);
    Get.lazyPut(() => MineQRCodeLogic(),fenix: true);
    Get.lazyPut(() => QRFriendAffirmLogic(),fenix: true);
    Get.lazyPut(() => QrOtherResultLogic(),fenix: true);
    Get.lazyPut(() => AboutLogic(),fenix: true);
    Get.lazyPut(() => FriendInformationLogic(),fenix: true);
    Get.lazyPut(() => SetRemarkLogic(),fenix: true);
    Get.lazyPut(() => SetGroupLogic(),fenix: true);
    Get.lazyPut(() => AddFriendLogic(),fenix: true);
    Get.lazyPut(() => SearchInfoLogic(),fenix: true);
    Get.lazyPut(() => FriendRequestLogic(),fenix: true);
    Get.lazyPut(() => TalkDetailsLogic(),fenix: true);
    Get.lazyPut(() => TalkCreateLogic(),fenix: true);
    Get.lazyPut(() => UserSelectLogic(),fenix: true);
    Get.lazyPut(() => ChatGroupInformationLogic(),fenix: true);
    Get.lazyPut(() => ImageViewerLogic(),fenix: true);
    Get.lazyPut(() => ImageViewerUpdateLogic(),fenix: true);
    Get.lazyPut(() => SetGroupNameLogic(),fenix: true);
    Get.lazyPut(() => SetGroupRemarkLogic(),fenix: true);
    Get.lazyPut(() => SetGroupNameNickLogic(),fenix: true);
    Get.lazyPut(() => ChatGroupNoticeLogic(),fenix: true);
    Get.lazyPut(() => AddChatGroupNoticeLogic(),fenix: true);
  }
}
