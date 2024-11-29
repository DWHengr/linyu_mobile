import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_label_value_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/talk/talk_create/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class TalkCreatePage extends CustomWidget<TalkCreateLogic> {
  TalkCreatePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('发表说说'),
        backgroundColor: const Color(0xFFF9FBFF),
        actions: [
          CustomTextButton('确定',
              onTap: controller.onCreateTalk,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              fontSize: 14),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: '记录当前时刻...',
                controller: controller.contentController,
                maxLines: 4,
                hintTextColor: theme.primaryColor,
              ),
              const SizedBox(height: 5),
              // 图片网格展示区域
              Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: controller.selectedImages.length < 9
                        ? controller.selectedImages.length + 1
                        : 9,
                    itemBuilder: (context, index) {
                      // 如果是最后一个位置且图片数量小于9，显示添加按钮
                      if (index == controller.selectedImages.length &&
                          controller.selectedImages.length < 9) {
                        return GestureDetector(
                          onTap: controller.pickImages,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF2F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      // 显示已选择的图片
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image:
                                    FileImage(controller.selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
              const SizedBox(height: 5),
              CustomLabelValueButton(
                label: '谁可以看',
                color: const Color(0xFFEDF2F9),
                onTap: controller.handlerToUserSelect,
                hint: controller.selectedUsers.isNotEmpty ? '已选中的用户' : '所有人可见',
                width: 80,
                child: controller.selectedUsers.isEmpty
                    ? const Text(
                        '所有人可见',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      )
                    : Wrap(
                        spacing: 2.0,
                        runSpacing: 2.0,
                        children: [
                          ...controller.selectedUsers
                              .map((user) => _buildUserItem(user)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserItem(user) {
    return Container(
      height: 26,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1),
        color: theme.searchBarColor,
      ),
      constraints: const BoxConstraints(maxWidth: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPortrait(
            url: user['portrait'] ?? '',
            size: 16,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              StringUtil.isNotNullOrEmpty(user['remark'])
                  ? user['remark']
                  : user['name'],
              style: const TextStyle(
                  fontSize: 12, overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }
}
