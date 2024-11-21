import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linyu_mobile/pages/chat_list/index.dart';
import 'package:linyu_mobile/pages/contacts/index.dart';
import 'package:linyu_mobile/pages/mine/index.dart';
import 'package:linyu_mobile/pages/navigation/logic.dart';
import 'package:linyu_mobile/pages/talk/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class NavigationPage extends CustomWidget<NavigationLogic> {
  NavigationPage({required super.key});

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return ChatListPage(key: const Key('chat_list'));
      case 1:
        return ContactsPage(key: const Key('contacts'));
      case 2:
        return TalkPage(key: const Key('talk'));
      case 3:
        return MinePage(key: const Key('mine'));
      default:
        return ChatListPage(key: const Key('chat_list'));
    }
  }

  Widget _buildUnreadTip(int count) {
    return Positioned(
      right: -10,
      top: -5,
      child: Container(
        height: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
        ),
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: _buildPage((controller.currentIndex)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.onTap,
          selectedItemColor: theme.primaryColor,
          showUnselectedLabels: true,
          backgroundColor: const Color(0xFFEDF2F9),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: List.generate(controller.unselectedIcons.length, (index) {
            return BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    controller.currentIndex == index
                        ? 'assets/images/${controller.selectedIcons[index]}-${theme.themeMode.value}.png'
                        : controller.unselectedIcons[index],
                    width: 26,
                    height: 26,
                  ),
                  if (controller.selectedIcons[index] == 'chat' &&
                      globalData.getUnreadCount('chat') > 0)
                    _buildUnreadTip(globalData.getUnreadCount('chat')),
                ],
              ),
              label: controller.name[index],
            );
          }),
        ),
      ),
    );
  }
}
