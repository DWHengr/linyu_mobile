import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_icon_button/index.dart';
import 'package:linyu_mobile/components/custom_label_value_button/index.dart';
import 'package:linyu_mobile/components/custom_least_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_shadow_text/index.dart';
import 'package:linyu_mobile/components/custom_update_portrait/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ChatGroupInformationPage extends CustomWidget<ChatGroupInformationLogic> {
  ChatGroupInformationPage({super.key});

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

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('群资料'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.minorColor, const Color(0xFFFFFFFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: CustomUpdatePortrait(
                                onTap: () => controller.selectPortrait(),
                                url: controller.chatGroupDetails['portrait'] ??
                                    '',
                                size: 70,
                                radius: 35),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomShadowText(
                                    text: controller.chatGroupDetails['name']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    CustomLabelValueButton(
                        onTap: () => {},
                        width: 60,
                        label: '群名称',
                        value: controller.chatGroupDetails['name']),
                    const SizedBox(height: 1),
                    CustomLabelValueButton(
                        onTap: () => {},
                        width: 60,
                        label: '群备注',
                        hint: '未设置备注',
                        value: controller.chatGroupDetails['groupRemark']),
                    const SizedBox(height: 1),
                    CustomLabelValueButton(
                        onTap: () => {},
                        width: 60,
                        label: '群昵称',
                        hint: '未设置昵称',
                        value: controller.chatGroupDetails['groupName']),
                    const SizedBox(height: 1),
                    CustomLabelValueButton(
                        onTap: () {},
                        width: 60,
                        label: '群公告',
                        hint: '暂无群公告~',
                        maxLines: 10,
                        value: controller.chatGroupDetails['notice']
                            ['noticeContent']),
                    const SizedBox(height: 1),
                    CustomLabelValueButton(
                      onTap: () {},
                      width: 140,
                      compact: false,
                      label:
                          '查看所有成员(${controller.chatGroupDetails['memberNum']})',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              ...controller.chatGroupMembers.map(
                                (member) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomPortrait(
                                      url: member['portrait'],
                                      size: 40,
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: Text(
                                          member['name'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              CustomIconButton(
                                onTap: () {},
                                icon: Icons.add,
                                text: '邀请成员',
                              ),
                              CustomIconButton(
                                onTap: () {},
                                icon: Icons.remove,
                                text: '移除成员',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (controller.isOwner)
                      CustomLeastButton(
                        onTap: () {},
                        text: '解散群聊',
                        textColor: const Color(0xFFFF4C4C),
                      ),
                    if (!controller.isOwner)
                      CustomLeastButton(
                        onTap: () {},
                        text: '退出群聊',
                        textColor: const Color(0xFFFF4C4C),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
