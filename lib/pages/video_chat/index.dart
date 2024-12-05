import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_animated_dots_text/index.dart';
import 'package:linyu_mobile/components/custom_icon_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/video_chat/logic.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class VideoChatPage extends CustomWidget<VideoChatLogic> {
  VideoChatPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.showExitConfirmDialog(context);
        },
        child: Scaffold(
          body: Stack(
            children: [
              StringUtil.isNotNullOrEmpty(controller.userInfo['portrait'] ?? '')
                  ? Image.network(
                      controller.userInfo['portrait'] ?? '',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.black,
                    ),
              // 模糊效果
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              // 主体内容
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 根据条件渲染内容
                    if (!controller.toUserIsReady ||
                        (controller.isOnlyAudio && controller.toUserIsReady))
                      buildAudioContent(),
                    if (controller.toUserIsReady && !controller.isOnlyAudio)
                      buildVideoContent(),
                  ],
                ),
              ),
              // 固定在底部的操作按钮
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildActionButtons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 构建音频页面的内容
  Widget buildAudioContent() {
    return Column(
      children: [
        CustomPortrait(
          url: controller.userInfo['portrait'] ?? '',
          size: 100,
        ),
        const SizedBox(height: 16),
        Text(
          StringUtil.isNullOrEmpty(controller.userInfo['remark'])
              ? controller.userInfo['name'] ?? ''
              : controller.userInfo['remark'] ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 10),
        if (controller.toUserIsReady && controller.isOnlyAudio)
          const CustomAnimatedDotsText(text: '正在语音通话中'),
        if (!controller.toUserIsReady)
          CustomAnimatedDotsText(
              text: controller.isSender ? '等待对方接听' : "对方请求通话"),
        const SizedBox(height: 60),
      ],
    );
  }

// 构建视频页面的内容
  Widget buildVideoContent() {
    return Expanded(
      child: Stack(
        children: [
          // 全屏视图
          Obx(
            () => RTCVideoView(
              controller.isRemoteFullScreen.value
                  ? controller.localRenderer
                  : controller.remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true,
            ),
          ),
          // 可拖动的小窗口
          Obx(() {
            return Positioned(
              left: controller.smallWindowOffset.value.dx,
              top: controller.smallWindowOffset.value.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  controller.updateSmallWindowPosition(details.delta);
                },
                onTap: () {
                  controller.isRemoteFullScreen.value =
                      !controller.isRemoteFullScreen.value;
                },
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: RTCVideoView(
                    controller.isRemoteFullScreen.value
                        ? controller.remoteRenderer
                        : controller.localRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

// 构建操作按钮
  Widget buildActionButtons() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Obx(() => Text(
                DateUtil.formatTimingTime(controller.time.value),
                style: const TextStyle(color: Colors.white),
              )),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CustomIconButton(
                icon: IconData(
                    controller.isAudioEnabled.value ? 0xe654 : 0xe653,
                    fontFamily: 'IconFont'),
                onTap: controller.toggleAudio,
                color: Colors.black.withOpacity(0.2),
                iconColor: Colors.white,
                iconSize: 22,
                width: 40,
                height: 40,
                radius: 40,
              ),
            ),
            const SizedBox(width: 20),
            CustomIconButton(
              icon: const IconData(0xe640, fontFamily: 'IconFont'),
              onTap: controller.onHangup,
              color: theme.errorColor,
              iconColor: Colors.white,
              width: 50,
              height: 50,
              radius: 18,
            ),
            if (!controller.isSender && !controller.toUserIsReady)
              const SizedBox(width: 30),
            if (!controller.isSender && !controller.toUserIsReady)
              CustomIconButton(
                icon: const IconData(0xe641, fontFamily: 'IconFont'),
                onTap: controller.onAccept,
                color: Get.theme.primaryColor,
                iconColor: Colors.white,
                width: 50,
                height: 50,
                radius: 18,
              ),
            const SizedBox(width: 20),
            if (!controller.isOnlyAudio)
              Obx(
                () => CustomIconButton(
                  icon: IconData(
                      controller.isVideoEnabled.value ? 0xeca6 : 0xeca5,
                      fontFamily: 'IconFont'),
                  onTap: controller.toggleVideo,
                  color: Colors.black.withOpacity(0.2),
                  iconColor: Colors.white,
                  iconSize: 22,
                  width: 40,
                  height: 40,
                  radius: 40,
                ),
              )
            else
              const SizedBox(width: 40),
          ],
        )
      ],
    );
  }
}
