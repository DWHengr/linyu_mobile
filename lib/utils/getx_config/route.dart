import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:linyu_mobile/pages/chat_list/index.dart';
import 'package:linyu_mobile/pages/contacts/index.dart';
import 'package:linyu_mobile/pages/login/index.dart';
import 'package:linyu_mobile/pages/mine/index.dart';
import 'package:linyu_mobile/pages/mine/mine_qr_code/index.dart';
import 'package:linyu_mobile/pages/navigation/index.dart';
import 'package:linyu_mobile/pages/password/retrieve/index.dart';
import 'package:linyu_mobile/pages/password/update/index.dart';
import 'package:linyu_mobile/pages/qr_code_scan/index.dart';
import 'package:linyu_mobile/pages/qr_login_affirm/index.dart';
import 'package:linyu_mobile/pages/register/index.dart';
import 'package:linyu_mobile/pages/talk/index.dart';

import 'package:linyu_mobile/pages/mine/edit/index.dart';
import 'ControllerBinding.dart';

class AppRoutes {
  static List<GetPage> pageRoute = [
    GetPage(
      name: '/',
      page: () => const NavigationPage(
        key: Key('main'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginPage(
        key: const Key('login'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterPage(
        key: const Key('register'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/retrieve_password',
      page: () => RetrievePassword(
        key: const Key('retrieve_password'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/update_password',
      page: () => UpdatePasswordPage(
        key: const Key('update_password'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/chat_list',
      page: () => ChatListPage(
        key: const Key('chat_list'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/contacts',
      page: () => ContactsPage(
        key: const Key('contacts'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/mine',
      page: () => MinePage(
        key: const Key('mine'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/talk',
      page: () => TalkPage(
        key: const Key('talk'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/qr_code_scan',
      page: () => QRCodeScanPage(
        key: const Key('qr_code_scan'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/qr_login_affirm',
      page: () => QrLoginAffirmPage(
        key: const Key('qr_login_affirm'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/edit_mine',
      page: () => EditMinePage(
        key: const Key('edit_mine'),
      ),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: '/mine_qr_code',
      page: () => MineQRCodePage(
        key: const Key('mine_qr_code'),
      ),
      binding: ControllerBinding(),
    ),
  ];
}
