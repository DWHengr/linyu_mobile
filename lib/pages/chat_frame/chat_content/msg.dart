import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/call.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/file.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/image.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/retraction.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/system.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/time.dart';
import 'package:linyu_mobile/pages/chat_frame/chat_content/voice.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'text.dart';

typedef CallBack = dynamic Function(dynamic data);

class ChatMessage extends StatelessThemeWidget {
  final Map<String, dynamic> msg;
  final Map<String, dynamic> chatInfo;
  final Map<String, dynamic>? member;

  // 点击复制回调
  final CallBack? onTapCopy;

  // 点击转发回调
  final CallBack? onTapRetransmission;

  // 点击删除回调
  final CallBack? onTapDelete;

  // 点击撤回回调
  final CallBack? onTapRetract;

  // 点击引用回调
  final CallBack? onTapCite;

  const ChatMessage({
    super.key,
    this.onTapCopy,
    this.onTapRetransmission,
    this.onTapDelete,
    this.onTapRetract,
    this.onTapCite,
    required this.msg,
    required this.chatInfo,
    required this.member,
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
        if (msg['type'] == 'system') SystemMessage(value: msg['msgContent']),
        // 群聊消息
        if (chatInfo['type'] == 'group' && msg['type'] != 'system')
          Align(
            alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment:
              isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isRight)
                  CustomPortrait(
                    url: msg['msgContent']?['formUserPortrait'],
                    size: 40,
                  ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: isRight
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _handlerGroupDisplayName(),
                      style: const TextStyle(
                        color: Color(0xFF969696),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 动态组件
                    getComponentByType(msg['msgContent']['type'], isRight),
                  ],
                ),
                const SizedBox(width: 5),
                if (isRight)
                  CustomPortrait(
                    url: msg['msgContent']?['formUserPortrait'],
                    size: 40,
                  ),
              ],
            ),
          ),
        // 私聊消息
        if (chatInfo['type'] == 'user')
          Align(
              alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  getComponentByType(msg['msgContent']['type'], isRight),
                  const SizedBox(width: 5),
                ],
              )),
        const SizedBox(height: 15),
      ],
    );
  }

  String _handlerGroupDisplayName() {
    if (member == null) {
      return msg['msgContent']?['formUserName'] ?? '';
    }
    if (member!.containsKey('groupName') && member!['groupName'] != null) {
      return member!['groupName']!;
    } else if (member!.containsKey('remark') && member!['remark'] != null) {
      return member!['remark']!;
    } else {
      return member!['name'] ?? '';
    }
  }

  List<PopMenuItemModel> menuItems() => [
    if(msg['msgContent']['type'] == 'text')PopMenuItemModel(
      title: '复制',
      icon: Icons.content_copy,
      callback:
      onTapCopy ?? (data) => debugPrint("data: ${data.toString()}"),
    ),
    PopMenuItemModel(
        title: '转发',
        icon: Icons.send,
        callback: onTapRetransmission ??
                (data) => debugPrint("data: ${data.toString()}")),
    // PopMenuItemModel(
    //     title: '收藏',
    //     icon: Icons.collections,
    //     callback: (data) {
    //       debugPrint("data: " + data);
    //     }),
    PopMenuItemModel(
        title: '删除',
        icon: Icons.delete,
        callback: onTapDelete ??
                (data) => debugPrint("data: ${data.toString()}")),
    if(msg['fromId'] == globalData.currentUserId)PopMenuItemModel(
        title: '撤回',
        icon: Icons.reply,
        callback: onTapRetract ??
                (data) => debugPrint("data: ${data.toString()}")),
    // PopMenuItemModel(
    //     title: '多选',
    //     icon: Icons.playlist_add_check,
    //     callback:  (data) {
    //       debugPrint("data: ${data.toString()}");
    //     }),
    PopMenuItemModel(
        title: '引用',
        icon: Icons.format_quote,
        callback:
        onTapCite ?? (data) => debugPrint("data: ${data.toString()}")),
    // PopMenuItemModel(
    //     title: '提醒',
    //     icon: Icons.add_alert,
    //     callback: (data) {
    //       debugPrint("data: " + data);
    //     }),
    // PopMenuItemModel(
    //     title: '搜一搜',
    //     icon: Icons.search,
    //     callback: (data) {
    //       debugPrint("data: " + data);
    //     }),
  ];

  Widget getComponentByType(String? type, bool isRight) {
    final messageMap = {
      'text': () => TextMessage(value: msg, isRight: isRight),
      'file': () => FileMessage(value: msg, isRight: isRight),
      'img': () => ImageMessage(value: msg, isRight: isRight),
      'retraction': () => RetractionMessage(isRight: isRight),
      'voice': () => VoiceMessage(value: msg, isRight: isRight),
      'call': () => CallMessage(value: msg, isRight: isRight),
    };

    if (messageMap.containsKey(type)) {
      return QuickPopUpMenu(
        showArrow: true,
        useGridView: false,
        pressType: PressType.longPress,
        menuItems: menuItems(),
        dataObj: messageMap[type]!(),
        child: messageMap[type]!(),
      ); // 调用对应的构建函数
    } else {
      // 异常处理
      return const Text('暂不支持该消息类型');
    }
  }
}
