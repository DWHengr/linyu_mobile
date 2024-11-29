import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/chat_frame/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ChatFramePage extends CustomWidget<ChatFrameLogic>
    with WidgetsBindingObserver {
  ChatFramePage({super.key});

  @override
  void init(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(Get.context!).viewInsets.bottom > 0) {
        controller.scrollBottom();
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF9FBFF),
        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle(
              StringUtil.isNotNullOrEmpty(controller.chatInfo['remark'])
                  ? controller.chatInfo['remark']
                  : controller.chatInfo['name']),
          backgroundColor: const Color(0xFFF9FBFF),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: controller.toDetailsPage,
                child: CustomPortrait(
                    url: controller.chatInfo['portrait'], size: 32),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            // 消息列表部分
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GetBuilder<ChatFrameLogic>(
                  id: const Key('chat_frame'),
                  builder: (controller) {
                    return Stack(
                      children: [
                        ListView(
                          cacheExtent: 99999,
                          controller: controller.scrollController,
                          children: [
                            if (!controller.hasMore)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '没有更多消息了',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ...controller.msgList
                                .map((msg) => _buildMsgContent(msg)),
                          ],
                        ),
                        if (controller.isLoading)
                          const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              color: const Color(0xFFEDF2F9),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(IconData(0xe602, fontFamily: 'IconFont'),
                          size: 26.0),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.msgContentController,
                          maxLines: 3,
                          minLines: 1,
                          hintTextColor: theme.primaryColor,
                          hintText: '请输入消息',
                          vertical: 8,
                          fillColor: Colors.white,
                          onTap: () => controller.scrollBottom(),
                          onChanged: (value) {
                            controller.isSend.value = value.trim().isNotEmpty;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(IconData(0xe632, fontFamily: 'IconFont'),
                          size: 26.0),
                      const SizedBox(width: 10),
                      Obx(() {
                        if (controller.isSend.value) {
                          return CustomButton(
                            text: '发送',
                            onTap: controller.sendTextMsg,
                            width: 60,
                            textSize: 14,
                            height: 34,
                          );
                        } else {
                          return const Icon(
                              IconData(0xe636, fontFamily: 'IconFont'),
                              size: 26.0);
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMsgContent(msg) {
    bool isRight = msg['fromId'] == globalData.currentUserId;
    return Column(
      children: [
        Align(
          alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isRight ? theme.primaryColor : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.8,
            ),
            child: Text(
              msg['msgContent']['content'],
              style: TextStyle(color: isRight ? Colors.white : Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void close(BuildContext context) {
    super.close(context);
    WidgetsBinding.instance.removeObserver(this);
  }
}
