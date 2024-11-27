import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_badge/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_member/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ChatGroupMemberPage extends CustomWidget<ChatGroupMemberLogic> {
  ChatGroupMemberPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFF),
        title: const AppBarTitle('成员列表'),
        centerTitle: true,
        actions: [
          CustomTextButton('邀请',
              onTap: controller.onInviteFriend,
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
                  ...controller.memberList
                      .map((user) => _buildUserItem(context, user)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(context, dynamic user) {
    final displayText = user['remark']?.isNotEmpty == true
        ? user['remark']
        : user['groupName']?.isNotEmpty == true
            ? user['groupName']
            : user['name'];
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
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
              CustomPortrait(url: user['portrait']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              displayText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (user['userId'] ==
                                controller.chatGroupDetails['ownerUserId'])
                              const CustomBadge(text: '群主'),
                          ],
                        ),
                        Row(
                          children: [
                            if (controller.isOwner && user['friendId'] != null)
                              CustomTextButton(
                                '转让',
                                onTap: () => controller.onTransferGroup(
                                    context, user['userId']),
                                fontSize: 14,
                              ),
                            if (user['friendId'] == null &&
                                user['userId'] != globalData.currentUserId)
                              CustomTextButton(
                                '添加',
                                onTap: () => controller.onAddFriend(
                                    context, user['userId']),
                                fontSize: 14,
                              ),
                            const SizedBox(width: 10),
                            if (controller.isOwner)
                              CustomTextButton(
                                '移除',
                                onTap: () => controller.onKickMember(
                                    context, user['userId']),
                                fontSize: 14,
                                textColor: theme.errorColor,
                              ),
                          ],
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
    );
  }
}
