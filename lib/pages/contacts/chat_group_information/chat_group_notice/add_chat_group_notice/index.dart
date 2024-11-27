import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/chat_group_notice/add_chat_group_notice/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class AddChatGroupNoticePage extends CustomWidget<AddChatGroupNoticeLogic> {
  AddChatGroupNoticePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle('编辑群公告'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            CustomTextButton('完成',
                onTap: controller.onAddNotice,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                fontSize: 14),
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(
              () => CustomTextField(
                // labelText: "群公告",
                controller: controller.noticeController,
                onChanged: (value) {
                  controller.noticeLength.value = value.length;
                },
                inputLimit: 100,
                hintText: "请输入群公告~",
                minLines: 8,
                maxLines: 8,
                hintTextColor: theme.primaryColor,
                suffix: Text('${controller.noticeLength.value}/100'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
