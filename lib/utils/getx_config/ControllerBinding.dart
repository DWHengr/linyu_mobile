import 'package:get/get.dart';
import 'package:linyu_mobile/pages/chat_frame/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_member/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/add_chat_group_notice/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_nickname/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_name/logic.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_remark/logic.dart';
import 'package:linyu_mobile/pages/contacts/create_chat_group/logic.dart';
import 'package:linyu_mobile/pages/contacts/create_chat_group/select_user/logic.dart';
import 'package:linyu_mobile/pages/file_details/logic.dart';
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
import 'package:linyu_mobile/pages/mine/system_notify/logic.dart';
import 'package:linyu_mobile/pages/navigation/logic.dart';
import 'package:linyu_mobile/pages/password/retrieve/logic.dart';
import 'package:linyu_mobile/pages/password/update/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_friend_affirm/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_login_affirm/logic.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_other_result/logic.dart';
import 'package:linyu_mobile/pages/re_forward/logic.dart';
import 'package:linyu_mobile/pages/register/logic.dart';
import 'package:linyu_mobile/pages/talk/logic.dart';
import 'package:linyu_mobile/pages/talk/talk_create/logic.dart';
import 'package:linyu_mobile/pages/talk/talk_details/logic.dart';
import 'package:linyu_mobile/pages/video_chat/logic.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalData.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:linyu_mobile/pages/mine/edit/logic.dart';

//依赖注入
class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GlobalThemeConfig>(GlobalThemeConfig(), permanent: true);
    Get.put<GlobalData>(GlobalData(), permanent: true);
    Get.lazyPut<NavigationLogic>(() => NavigationLogic(), fenix: true);
    Get.lazyPut<LoginPageLogic>(() => LoginPageLogic(), fenix: true);
    Get.lazyPut<RegisterPageLogic>(() => RegisterPageLogic(), fenix: true);
    Get.lazyPut<RetrievePasswordLogic>(() => RetrievePasswordLogic(),
        fenix: true);
    Get.lazyPut<UpdatePasswordLogic>(() => UpdatePasswordLogic(), fenix: true);
    Get.lazyPut<ChatListLogic>(() => ChatListLogic(), fenix: true);
    Get.lazyPut<ContactsLogic>(() => ContactsLogic(), fenix: true);
    Get.lazyPut<MineLogic>(() => MineLogic(), fenix: true);
    Get.lazyPut<TalkLogic>(() => TalkLogic(), fenix: true);
    Get.lazyPut<QRCodeScanLogic>(() => QRCodeScanLogic(), fenix: true);
    Get.lazyPut<QRLoginAffirmLogic>(() => QRLoginAffirmLogic(), fenix: true);
    Get.lazyPut<EditMineLogic>(() => EditMineLogic(), fenix: true);
    Get.lazyPut<MineQRCodeLogic>(() => MineQRCodeLogic(), fenix: true);
    Get.lazyPut<QRFriendAffirmLogic>(() => QRFriendAffirmLogic(), fenix: true);
    Get.lazyPut<QrOtherResultLogic>(() => QrOtherResultLogic(), fenix: true);
    Get.lazyPut<AboutLogic>(() => AboutLogic(), fenix: true);
    Get.lazyPut<FriendInformationLogic>(() => FriendInformationLogic(),
        fenix: true);
    Get.lazyPut<SetRemarkLogic>(() => SetRemarkLogic(), fenix: true);
    Get.lazyPut<SetGroupLogic>(() => SetGroupLogic(), fenix: true);
    Get.lazyPut<AddFriendLogic>(() => AddFriendLogic(), fenix: true);
    Get.lazyPut<SearchInfoLogic>(() => SearchInfoLogic(), fenix: true);
    Get.lazyPut<FriendRequestLogic>(() => FriendRequestLogic(), fenix: true);
    Get.lazyPut<TalkDetailsLogic>(() => TalkDetailsLogic(), fenix: true);
    Get.lazyPut<TalkCreateLogic>(() => TalkCreateLogic(), fenix: true);
    Get.lazyPut<UserSelectLogic>(() => UserSelectLogic(), fenix: true);
    Get.lazyPut<ChatGroupInformationLogic>(() => ChatGroupInformationLogic(),
        fenix: true);
    Get.lazyPut<ImageViewerLogic>(() => ImageViewerLogic(), fenix: true);
    Get.lazyPut<ImageViewerUpdateLogic>(() => ImageViewerUpdateLogic(),
        fenix: true);
    Get.lazyPut<SetGroupNameLogic>(() => SetGroupNameLogic(), fenix: true);
    Get.lazyPut<SetGroupRemarkLogic>(() => SetGroupRemarkLogic(), fenix: true);
    Get.lazyPut<SetGroupNameNickLogic>(() => SetGroupNameNickLogic(),
        fenix: true);
    Get.lazyPut<ChatGroupNoticeLogic>(() => ChatGroupNoticeLogic(),
        fenix: true);
    Get.lazyPut<AddChatGroupNoticeLogic>(() => AddChatGroupNoticeLogic(),
        fenix: true);
    Get.lazyPut<ChatGroupMemberLogic>(() => ChatGroupMemberLogic(),
        fenix: true);
    Get.lazyPut<CreateChatGroupLogic>(() => CreateChatGroupLogic(),
        fenix: true);
    Get.lazyPut<SystemNotifyLogic>(() => SystemNotifyLogic(), fenix: true);
    Get.lazyPut<ChatGroupSelectUserLogic>(() => ChatGroupSelectUserLogic(),
        fenix: true);
    Get.lazyPut<ChatFrameLogic>(() => ChatFrameLogic(), fenix: true);
    Get.lazyPut<FileDetailsLogic>(() => FileDetailsLogic(), fenix: true);
    Get.lazyPut<VideoChatLogic>(() => VideoChatLogic(), fenix: true);
    Get.lazyPut<ReForwardLogic>(() => ReForwardLogic(), fenix: true);
  }
}
