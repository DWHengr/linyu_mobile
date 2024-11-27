// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_group/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class SetGroupPage extends CustomWidgetNew<SetGroupLogic> {
  SetGroupPage({super.key});

  void showAddAndUpdateGroupDialog(
    BuildContext context, {
    dynamic group,
    String? title = "添加分组",
    String? label = '请填写新的分组名称',
    String? hintText = '分组名称',
  }) =>
      showDialog(
        context: context,
        barrierDismissible: false, // 设置为 false 禁止点击外部关闭弹窗
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    vertical: 8,
                    controller: controller.groupController,
                    inputLimit: 10,
                    hintText: hintText!,
                    suffix:
                        Text('${controller.groupController.text.length}/10'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: '确定',
                          onTap: () => controller.onUpdateGroup(context, group),
                          width: 120,
                          height: 34,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: '取消',
                          onTap: () => Navigator.of(context).pop(),
                          type: 'minor',
                          height: 34,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

  void _showGroupBottomSheet(BuildContext context, dynamic group) =>
      Get.bottomSheet(
        backgroundColor: Colors.white,
        Wrap(
          children: [
            Center(
              child: TextButton(
                onPressed: ()=>controller.onUpdateGroupPress(context,group),
                child: Text(
                  '重新命名',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => controller.onDeleteGroup(group),
                child: const Text(
                  '删除分组',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF9FBFF),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const AppBarTitle('好友分组'),
            centerTitle: true,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            actions: [
              CustomTextButton('添加',
                  onTap: () => showAddAndUpdateGroupDialog(context),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  fontSize: 14),
            ]),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...controller.groupList.map(
                  (group) => Column(
                    children: [
                      CustomMaterialButton(
                        onLongPress: () =>
                            _showGroupBottomSheet(context, group),
                        onTap: () => controller.onSetGroup(group),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  group['label'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (controller.selectedGroup == group['label'])
                                Icon(Icons.check,
                                    color: theme.primaryColor, size: 24)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
