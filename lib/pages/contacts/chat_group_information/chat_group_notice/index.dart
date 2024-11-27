import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/logic.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ChatGroupNoticePage extends CustomWidget<ChatGroupNoticeLogic> {
  ChatGroupNoticePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle('群公告'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            if (controller.isOwner)
              CustomTextButton('创建',
                  onTap: controller.handlerAddNotice,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  fontSize: 14),
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...controller.chatGroupNoticeList
                  .map((notice) => _buildNoticeItem(notice, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeItem(notice, context) {
    return Column(
      children: [
        CustomMaterialButton(
          onTap: () {
            if (globalData.currentUserId == notice['userId']) {
              controller.handlerEditNotice(
                  notice['id'], notice['noticeContent']);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomPortrait(url: notice['portrait'], size: 26),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${notice['name']}',
                            style: const TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          DateUtil.formatTime(notice['createTime']),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    if (globalData.currentUserId == notice['userId'])
                      CustomTextButton('删除',
                          onTap: () => controller.onDelChatGroupNotice(
                              context, notice['id'])),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${notice['noticeContent']}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
