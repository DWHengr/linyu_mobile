import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_tip/index.dart';
import 'package:linyu_mobile/pages/contacts/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ContactsPage extends CustomWidget<ContactsLogic> {
  ContactsPage({super.key});

  @override
  init(BuildContext context) {
    controller.init();
  }

  Widget getContent(String tab) {
    switch (tab) {
      case '好友通知':
        return ListView(
          children: [
            ...controller.notifyFriendList.map((notify) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildNotifyFriendItem(notify),
                )),
          ],
        );
      case '我的群聊':
        return ListView(
          children: [
            ...controller.chatGroupList.map(
              (group) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildChatGroupItem(group),
              ),
            ),
          ],
        );
      case '我的好友':
        return ListView(
          children: [
            ...controller.friendList.map((group) {
              return GestureDetector(
                onLongPress: controller.onLongPressGroup,
                child: ExpansionTile(
                  iconColor: theme.primaryColor,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  dense: true,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    '${group['name']}（${group['friends'].length}）',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    ...group['friends'].map(
                      (friend) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: _buildFriendItem(friend),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildNotifyFriendItem(dynamic notify) {
    bool isFromCurrentUser = controller.currentUserId == notify['fromId'];
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: controller.onReadNotify,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CustomPortrait(
                    url: isFromCurrentUser
                        ? notify['toPortrait']
                        : notify['fromPortrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isFromCurrentUser
                                ? notify['toName']
                                : notify['fromName'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getNotifyContentTip(
                            notify['status'], isFromCurrentUser),
                        style:
                            TextStyle(fontSize: 12, color: theme.primaryColor),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              notify['content'],
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                _getNotifyOperateTip(
                    notify['status'], isFromCurrentUser, notify),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getNotifyContentTip(status, isFromCurrentUser) {
    if (!isFromCurrentUser) return "请求加你为好友";
    switch (status) {
      case "wait":
        {
          return "正在验证请求";
        }
      case "reject":
        {
          return "已拒绝申请请求";
        }
      case "agree":
        {
          return "已同意申请请求";
        }
    }
    return "";
  }

  Widget _getNotifyOperateTip(status, isFromCurrentUser, [dynamic notify]) {
    if (!isFromCurrentUser && status == "wait") {
      return Row(
        children: [
          CustomTextButton(
            "同意",
            onTap: () => controller.handlerAgreeFriend(notify),
          ),
          const SizedBox(width: 10),
          CustomTextButton(
            "拒绝",
            onTap: () => controller.handlerRejectFriend(notify),
            textColor: Colors.grey[600],
          ),
          const SizedBox(width: 5),
        ],
      );
    }
    switch (status) {
      case "wait":
        {
          return Text(
            "等待验证",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
      case "reject":
        {
          return Text(
            "已拒绝",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
      case "agree":
        {
          return Text(
            "已同意",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
    }
    return const Text("");
  }

  Widget _buildChatGroupItem(dynamic group) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: () => Get.toNamed('/chat_group_info',
            arguments: {'chatGroupId': group['id']}),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CustomPortrait(url: group['portrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            group['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (group['groupRemark'] != null &&
                              group['groupRemark']?.toString().trim() != '')
                            Text(
                              '(${group['groupRemark']})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteGroupBottomSheet(dynamic friend) => Get.bottomSheet(
        backgroundColor: Colors.white,
        Wrap(
          children: [
            Center(
              child: TextButton(
                onPressed: () => controller.onSetConcernFriend(friend),
                child: Text(
                  friend['isConcern'] ? '取消特别关心' : '设置特别关心',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildFriendItem(dynamic friend) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onLongPress: () => _showDeleteGroupBottomSheet(friend),
        onTap: () => controller.handlerFriendTapped(friend),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CustomPortrait(url: friend['portrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            friend['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (friend['remark'] != null &&
                              friend['remark']?.toString().trim() != '')
                            Text(
                              '(${friend['remark']})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('通讯列表'),
        backgroundColor: const Color(0xFFF9FBFF),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add, size: 32),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: const Color(0xFFFFFFFF),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                height: 40,
                onTap: () => Get.toNamed('/qr_code_scan'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconData(0xe61e, fontFamily: 'IconFont'), size: 20),
                    SizedBox(width: 12),
                    Text('扫一扫', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              _buildPopupDivider(),
              PopupMenuItem(
                value: 1,
                height: 40,
                onTap: () => Get.toNamed('/add_friend'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, size: 20),
                    SizedBox(width: 12),
                    Text('添加好友', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              _buildPopupDivider(),
              PopupMenuItem(
                value: 2,
                height: 40,
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group_add, size: 20),
                    SizedBox(width: 12),
                    Text('创建群聊', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: Column(
          children: [
            CustomSearchBox(
              isCentered: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(controller.tabs.length, (index) {
                return Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => controller.handlerTabTapped(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  index == controller.selectedIndex ? 4.0 : 0.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: index == controller.selectedIndex
                                      ? theme.primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: index == controller.selectedIndex
                                      ? theme.primaryColor
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                                child: GestureDetector(
                                  onLongPress: controller.onLongPressGroup,
                                  child: Text(controller.tabs[index]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index == 2)
                        Obx(() => globalData.getUnreadCount('friendNotify') > 0
                            ? CustomTip(
                                globalData.getUnreadCount('friendNotify'),
                                right: 7,
                                top: -2)
                            : const SizedBox.shrink()),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: getContent(controller.tabs[controller.selectedIndex]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuEntry<int> _buildPopupDivider() {
    return PopupMenuItem<int>(
      enabled: false,
      height: 1,
      child: Container(
        height: 1,
        padding: const EdgeInsets.all(0),
        color: Colors.grey[200],
      ),
    );
  }
}
