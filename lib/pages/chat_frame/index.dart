import 'package:chat_bottom_container/panel_container.dart';
import 'package:chat_bottom_container/typedef.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_icon_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/components/custom_voice_record_buttom/index.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/msg.dart';
import 'package:linyu_mobile/pages/chat_frame/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/emoji.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

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
    final keyboardHeight = MediaQuery.of(Get.context!).viewInsets.bottom;
    if (keyboardHeight > 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.scrollController.hasClients) {
            controller.scrollController.animateTo(
              controller.scrollController.position.maxScrollExtent + 500,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
            );
          }
        });
      });
    }
  }

  final panelController = ChatBottomPanelContainerController<PanelType>();

  PanelType currentPanelType = PanelType.none;

  @override
  Widget buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.panelType.value = 'none';
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  hidePanel();
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
                              ...controller.msgList.map(
                                (msg) => GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    hidePanel();
                                  },
                                  child: ChatMessage(
                                    msg: msg,
                                    chatInfo: controller.chatInfo,
                                    member: controller.members[msg['fromId']],
                                  ),
                                ),
                              ),
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
            Obx(() {
              return Container(
                color: const Color(0xFFEDF2F9),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (controller.isRecording.value)
                          _buildIconButton1(
                            const IconData(0xe661, fontFamily: 'IconFont'),
                            () {
                              controller.isRecording.value = false;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                controller.focusNode.requestFocus();
                              });
                            },
                          )
                        else
                          _buildIconButton1(
                            const IconData(0xe7e2, fontFamily: 'IconFont'),
                            () {
                              controller.isRecording.value = true;
                              hidePanel();
                            },
                          ),
                        const SizedBox(width: 5),
                        if (controller.isRecording.value)
                          Expanded(
                            child: CustomVoiceRecordButton(
                                onFinish: controller.onSendVoiceMsg),
                          )
                        else
                          Expanded(
                            child: Obx(
                              () => CustomTextField(
                                controller: controller.msgContentController,
                                maxLines: 3,
                                minLines: 1,
                                readOnly: controller.isReadOnly.value,
                                hintTextColor: theme.primaryColor,
                                hintText: '请输入消息',
                                vertical: 8,
                                focusNode: controller.focusNode,
                                fillColor: Colors.white.withOpacity(0.9),
                                onTap: () {
                                  controller.isReadOnly.value = false;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    panelController.updatePanelType(
                                        ChatBottomPanelType.keyboard);
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    controller.scrollBottom();
                                  });
                                },
                                onChanged: (value) {
                                  controller.isSend.value =
                                      value.trim().isNotEmpty;
                                },
                              ),
                            ),
                          ),
                        const SizedBox(width: 5),
                        if (!controller.isRecording.value)
                          _buildIconButton1(
                            const IconData(0xe632, fontFamily: 'IconFont'),
                            () {
                              controller.isReadOnly.value = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                panelController.updatePanelType(
                                    ChatBottomPanelType.other,
                                    data: PanelType.emoji,
                                    forceHandleFocus:
                                        ChatBottomHandleFocus.requestFocus);
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                controller.scrollBottom();
                              });
                            },
                          ),
                        if (controller.isSend.value)
                          CustomButton(
                            text: '发送',
                            onTap: controller.sendTextMsg,
                            width: 60,
                            textSize: 14,
                            height: 34,
                          )
                        else
                          _buildIconButton1(
                            const IconData(0xe636, fontFamily: 'IconFont'),
                            () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                panelController.updatePanelType(
                                    ChatBottomPanelType.other,
                                    data: PanelType.tool);
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  controller.scrollBottom();
                                });
                              });
                            },
                          ),
                      ],
                    ),
                    _buildPanelContainer(),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelContainer() {
    return ChatBottomPanelContainer<PanelType>(
      controller: panelController,
      inputFocusNode: controller.focusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case PanelType.emoji:
            return _buildEmoji();
          case PanelType.tool:
            return _buildMoreOperation();
          default:
            return const SizedBox.shrink();
        }
      },
      panelBgColor: Colors.transparent,
      changeKeyboardPanelHeight: (height) {
        return height;
      },
    );
  }

  void hidePanel() {
    if (controller.focusNode.hasFocus) {
      controller.focusNode.unfocus();
    }
    controller.isReadOnly.value = false;
    panelController.updatePanelType(ChatBottomPanelType.none);
  }

  Widget _buildEmoji() {
    double height = 300;
    final keyboardHeight = panelController.keyboardHeight;
    if (keyboardHeight != 0) {
      height = keyboardHeight;
    }
    return SizedBox(
      height: height,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: MediaQuery.of(Get.context!).size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: Emoji.emojis
                      .map(
                        (emoji) => GestureDetector(
                          onTap: () {
                            final text = controller.msgContentController.text;
                            final selection =
                                controller.msgContentController.selection;
                            final newText = text.replaceRange(
                              selection.start,
                              selection.end,
                              emoji,
                            );
                            controller.msgContentController.value =
                                TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(
                                offset: selection.start + emoji.length,
                              ),
                            );
                          },
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOperation() {
    double height = 300;
    final keyboardHeight = panelController.keyboardHeight;
    if (keyboardHeight != 0) {
      height = keyboardHeight;
    }
    return SizedBox(
      height: height,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              height: height,
              width: MediaQuery.of(Get.context!).size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                children: [
                  _buildIconButton2(
                    '图片',
                    const IconData(0xe9f4, fontFamily: 'IconFont'),
                    () => controller.cropChatBackgroundPicture(null),
                  ),
                  _buildIconButton2(
                    '拍照',
                    const IconData(0xe9f3, fontFamily: 'IconFont'),
                    () => controller
                        .cropChatBackgroundPicture(ImageSource.camera),
                  ),
                  _buildIconButton2(
                    '文件',
                    const IconData(0xeac4, fontFamily: 'IconFont'),
                    () => controller.selectFile(),
                  ),
                  if (controller.chatInfo['type'] == 'user')
                    _buildIconButton2(
                      '语音通话',
                      const IconData(0xe969, fontFamily: 'IconFont'),
                      () => controller.onInviteVideoChat(true),
                    ),
                  if (controller.chatInfo['type'] == 'user')
                    _buildIconButton2(
                      '视频通话',
                      const IconData(0xe9f5, fontFamily: 'IconFont'),
                      () => controller.onInviteVideoChat(false),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton1(iconData, onTap) {
    return CustomIconButton(
      onTap: onTap,
      icon: iconData,
      width: 36,
      height: 36,
      iconSize: 26,
      iconColor: Colors.black,
      color: Colors.transparent,
    );
  }

  Widget _buildIconButton2(text, iconData, onTap) {
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

  @override
  void close(BuildContext context) {
    super.close(context);
    WidgetsBinding.instance.removeObserver(this);
  }
}
