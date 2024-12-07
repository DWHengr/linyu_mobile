import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:linyu_mobile/utils/extension.dart';
import 'logic.dart';

class ChatGroupSelectUserPage
    extends CustomWidgetNew<ChatGroupSelectUserLogic> {
  ChatGroupSelectUserPage({super.key});

  Widget _selectedUserItem(dynamic user) => Container(
        width: 38.6,
        margin: const EdgeInsets.only(right: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19.3),
        ),
        child: GestureDetector(
          onTap: () => controller.subUsers(user),
          child: CustomPortrait(
              isGreyColor: user['isDelete'],
              url: user['portrait'],
              size: 70,
              radius: 35),
        ),
      );

  Widget _buildFriendItem(dynamic friend) => Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () => controller.onSelect(friend),
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
                  Checkbox(
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return controller.users.include(friend)
                            ? theme.primaryColor
                            : theme.searchBarColor;
                      }
                      return Colors.transparent;
                    }),
                    value: controller.users.include(friend),
                    onChanged: (bool? value) => controller.onSelect(friend),
                    splashRadius: 5,
                  ),
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

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF9FBFF),
        appBar: AppBar(
          leading: TextButton(
            child: Text(
              '取消',
              style: TextStyle(color: theme.primaryColor),
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const AppBarTitle('选择好友'),
          backgroundColor: const Color(0xFFF9FBFF),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: controller.onBackKeyPress,
                      child: CustomSearchBox(
                        textEditingController: controller.searchBoxController,
                        prefix: controller.users.isNotEmpty
                            ? SizedBox(
                                height: 36.8,
                                width: controller.userTapWidth >= 200
                                    ? 210
                                    : controller.userTapWidth,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: controller.users
                                      .map((user) => _selectedUserItem(user))
                                      .toList(),
                                ),
                              )
                            : null,
                        isCentered: false,
                        onChanged: (value) => controller.onSearchFriend(value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView(
                    children: [
                      if (controller.searchList.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "搜索结果",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        ...controller.searchList
                            .map((friend) => _buildFriendItem(friend)),
                      ],
                      ...controller.friendList.map((group) {
                        return ExpansionTile(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: _buildFriendItem(friend),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomButton(
          text: '完成(${controller.users.length})',
          onTap: controller.onSubmitPress,
          width: MediaQuery.of(context).size.width,
          type: 'gradient',
        ),
      );
}
