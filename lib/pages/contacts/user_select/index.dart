import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/pages/contacts/user_select/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class UserSelectPage extends CustomWidget<UserSelectLogic> {
  UserSelectPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFF),
        title: const AppBarTitle('选择好友'),
        centerTitle: true,
        actions: [
          CustomTextButton('确定',
              onTap: () => Get.back(result: controller.selectedUsers),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              fontSize: 14),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomSearchBox(
              isCentered: false,
              onChanged: (value) => {controller.handlerSearchUser(value)},
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                children: [
                  ...controller.userList.map((user) => _buildUserItem(user)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(dynamic user) {
    bool isOnly = controller.onlyUsers.any((id) => id == user['friendId']);
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (!isOnly) controller.handlerSelectUser(user);
        },
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
                  checkColor: isOnly ? Colors.grey : theme.primaryColor,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return isOnly
                          ? Colors.grey.withOpacity(0.1)
                          : theme.searchBarColor;
                    }
                    return Colors.transparent;
                  }),
                  side: const BorderSide(
                    width: 1.5,
                    color: Colors.grey,
                  ),
                  value: isOnly
                      ? true
                      : controller.selectedUsers.any((selected) =>
                          selected['friendId'] == user['friendId']),
                  onChanged: (_) {
                    if (!isOnly) controller.handlerSelectUser(user);
                  },
                ),
                CustomPortrait(url: user['portrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (user['remark'] != null &&
                              user['remark']?.toString().trim() != '')
                            Text(
                              '(${user['remark']})',
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
}
