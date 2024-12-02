import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_label_value_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/contacts/create_chat_group/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CreateChatGroupPage extends CustomWidget<CreateChatGroupLogic> {
  CreateChatGroupPage({super.key});

  Widget _selectedUserItem(dynamic user) {
    return Container(
      width: 20,
      margin: const EdgeInsets.only(right: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPortrait(
          isGreyColor: user['isDelete'],
          url: user['portrait'],
          size: 20,
          radius: 10),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle('创建群聊'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            CustomTextButton('完成',
                onTap: controller.onCreateChatGroup,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                fontSize: 14),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CustomTextField(
                    labelText: "群名称",
                    controller: controller.nameController,
                    inputLimit: 10,
                    hintText: "请输入群名称~",
                    onChanged: controller.onRemarkChanged,
                    suffix: Text('${controller.nameLength}/10'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CustomTextField(
                    labelText: "群公告",
                    controller: controller.noticeController,
                    inputLimit: 100,
                    hintText: "输入群公告~",
                    maxLines: 4,
                    onChanged: controller.onNoticeTextChanged,
                    suffix: Text('${controller.noticeLength}/100'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomLabelValueButton(
              label: '邀请好友',
              color: const Color(0xFFEDF2F9),
              width: 80,
              onTap: () => Get.toNamed('/chat_group_select_user'),
              child: controller.users.isNotEmpty
                  ? SizedBox(
                      width: 70,
                      height: 20,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.users
                            .map((user) => _selectedUserItem(user))
                            .toList(),
                      ),
                    )
                  : const Text(
                      '暂无好友',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
