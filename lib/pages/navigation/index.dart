import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linyu_mobile/pages/chat_list/index.dart';
import 'package:linyu_mobile/pages/contacts/index.dart';
import 'package:linyu_mobile/pages/mine/index.dart';
import 'package:linyu_mobile/pages/navigation/logic.dart';
import 'package:linyu_mobile/pages/talk/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class NavigationPage extends CustomWidgetObx<NavigationLogic> {
  const NavigationPage({required super.key});

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return ChatListPage();
      case 1:
        return ContactsPage();
      case 2:
        return TalkPage();
      case 3:
        return MinePage();
      default:
        return ChatListPage();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Obx(() => _buildPage((controller.currentIndex.value))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.onTap,
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        backgroundColor: const Color(0xFFEDF2F9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(controller.unselectedIcons.length, (index) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              controller.currentIndex == index
                  ? controller.selectedIcons[index]
                  : controller.unselectedIcons[index],
              width: 26,
              height: 26,
            ),
            label: controller.name[index],
          );
        }),
      ),
    );
  }
}
