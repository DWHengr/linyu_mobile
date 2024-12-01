import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/call.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/file.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/image.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/retraction.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/time.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/voice.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'text.dart';

class ChatMessage extends StatelessThemeWidget {
  final Map<String, dynamic> msg;
  final Map<String, dynamic> chatInfo;

  const ChatMessage({
    super.key,
    required this.msg,
    required this.chatInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool isRight = msg['fromId'] == globalData.currentUserId;
    return Column(
      children: [
        // 时间组件
        if (msg['isShowTime'] == true)
          TimeContent(value: DateUtil.formatTime(msg['createTime'])),
        // 系统消息
        if (msg['type'] == 'system')
          Text(DateUtil.formatTime(msg['msgContent']['content'])),
        // 群聊消息
        if (chatInfo['type'] == 'group' && msg['type'] != 'system')
          Align(
            alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment:
                  isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isRight)
                  CustomPortrait(
                    url: msg['msgContent']?['formUserPortrait'],
                  ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户名
                    if (!isRight)
                      Text(
                        msg['msgContent']?['formUserName'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 12,
                        ),
                      ),
                    // 动态组件

                    getComponentByType(msg['msgContent']['type'], isRight),
                  ],
                ),
                if (isRight)
                  CustomPortrait(
                    url: msg['msgContent']?['formUserPortrait'],
                  ),
              ],
            ),
          ),

        // 私聊消息
        if (chatInfo['type'] == 'user')
          Align(
            alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
            child: getComponentByType(msg['msgContent']['type'], isRight),
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget getComponentByType(String? type, bool isRight) {
    switch (type) {
      case 'text':
        return TextMessage(
          value: msg,
          isRight: isRight,
        );
      case 'file':
        return FileMessage(value: msg, isRight: isRight);
      case 'img':
        return ImageMessage(value: msg, isRight: isRight);
      case 'retraction':
        return RetractionMessage(isRight: isRight);
      case 'voice':
        return VoiceMessage(value: msg, isRight: isRight);
      case 'call':
        return CallMessage(value: msg, isRight: isRight);
      default:
        return const Text('暂不支持该消息类型');
    }
  }
}
