import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_icon_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/msg.dart';
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
    final keyboardHeight = MediaQuery.of(Get.context!).viewInsets.bottom;
    if (keyboardHeight == 0) {
      controller.isShowMore.value = false;
    }
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
              child: GestureDetector(
                onTap: () {
                  controller.isShowMore.value = false;
                },
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
                              ...controller.msgList.map((msg) => ChatMessage(
                                  msg: msg, chatInfo: controller.chatInfo)),
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
                      CustomIconButton(
                        onTap: () {},
                        icon: const IconData(0xe602, fontFamily: 'IconFont'),
                        width: 36,
                        height: 36,
                        iconSize: 26,
                        iconColor: Colors.black,
                        color: Colors.transparent,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomTextField(
                          controller: controller.msgContentController,
                          maxLines: 3,
                          minLines: 1,
                          hintTextColor: theme.primaryColor,
                          hintText: '请输入消息',
                          vertical: 8,
                          fillColor: Colors.white.withOpacity(0.9),
                          onTap: () {
                            controller.isShowMore.value = false;
                            controller.scrollBottom();
                          },
                          onChanged: (value) {
                            controller.isSend.value = value.trim().isNotEmpty;
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      CustomIconButton(
                        onTap: () {},
                        icon: const IconData(0xe632, fontFamily: 'IconFont'),
                        width: 36,
                        height: 36,
                        iconSize: 26,
                        iconColor: Colors.black,
                        color: Colors.transparent,
                      ),
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
                          return CustomIconButton(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              controller.isShowMore.value =
                                  !controller.isShowMore.value;
                              if (controller.isShowMore.value) {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  controller.scrollBottom();
                                });
                              }
                            },
                            icon:
                                const IconData(0xe636, fontFamily: 'IconFont'),
                            width: 36,
                            height: 36,
                            iconSize: 26,
                            iconColor: Colors.black,
                            color: Colors.transparent,
                          );
                        }
                      }),
                    ],
                  ),
                  Obx(() {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: controller.isShowMore.value ? 240 : 0,
                      child: controller.isShowMore.value
                          ? _buildMoreOperation()
                          : Container(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOperation() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildIconButton(
            '语音通话',
            const IconData(0xe969, fontFamily: 'IconFont'),
            () => controller.onInviteVideoChat(true),
          ),
          _buildIconButton(
            '视频通话',
            const IconData(0xe9f5, fontFamily: 'IconFont'),
            () => controller.onInviteVideoChat(false),
          ),
          _buildIconButton(
            '图片',
            const IconData(0xe9f4, fontFamily: 'IconFont'),
            () => {},
          ),
          _buildIconButton(
            '文件',
            const IconData(0xeac4, fontFamily: 'IconFont'),
            () => {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(text, iconData, onTap) {
    return CustomIconButton(
      onTap: onTap,
      icon: iconData,
      width: 50,
      height: 50,
      radius: 15,
      iconSize: 26,
      text: text,
      color: Colors.white.withOpacity(0.9),
      iconColor: const Color(0xFF1F1F1F),
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
