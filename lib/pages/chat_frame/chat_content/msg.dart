import 'dart:convert';

import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
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
  const ChatMessage({
    super.key,
    required this.msg,
    required this.chatInfo,
    required this.member,
    this.chatPortrait = 'http://192.168.101.4:9000/linyu/default-portrait.jpg',
    this.onTapCopy,
    this.onTapRepost,
    this.onTapDelete,
    this.onTapRetract,
    this.onTapCite,
    this.onTapMsg,
    this.reEdit,
    this.onTapVoiceToText,
    this.onTapVoiceHiddenText,
    this.onTapMultipleChoice,
    this.onTapRemind,
    this.onTapSearch,
    this.onTapFavorite,
  });

  final Map<String, dynamic> msg, chatInfo;
  final Map<String, dynamic>? member;
  final String? chatPortrait;
  final void Function()? onTapMsg, reEdit;

  // 点击复制回调
  final CallBack? onTapCopy;

  // 点击转发回调
  final CallBack? onTapRepost;

  // 点击收藏回调
  final CallBack? onTapFavorite;

  // 点击删除回调
  final CallBack? onTapDelete;

  // 点击撤回回调
  final CallBack? onTapRetract;

  // 点击引用回调
  final CallBack? onTapCite;

  // 点击转文字回调
  final CallBack? onTapVoiceToText;

  // 点击隐藏文字回调
  final CallBack? onTapVoiceHiddenText;

  // 点击多选回调
  final CallBack? onTapMultipleChoice;

  // 点击提醒回调
  final CallBack? onTapRemind;

  // 点击搜一搜回调
  final CallBack? onTapSearch;

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
              mainAxisAlignment: msg['msgContent']['type'] == 'retraction'
                  ? MainAxisAlignment.center
                  : isRight
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isRight && msg['msgContent']['type'] != 'retraction')
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
                    if (msg['msgContent']['type'] != 'retraction')
                      Text(
                        _handlerGroupDisplayName(),
                        style: const TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 5),
                    // 动态组件
                    _getComponentByType(msg, isRight),
                  ],
                ),
                if (msg['msgContent']['type'] == 'retraction' &&
                    isRight &&
                    msg['msgContent']['ext'] != null &&
                    msg['msgContent']['ext'] == 'text')
                  const SizedBox(width: 1.2),
                if (msg['msgContent']['type'] == 'retraction' &&
                    isRight &&
                    msg['msgContent']['ext'] != null &&
                    msg['msgContent']['ext'] == 'text')
                  Column(
                    children: [
                      const SizedBox(height: 6),
                      CustomTextButton('重新编辑',
                          fontSize: 12,
                          onTap: reEdit ??
                                  () {
                                debugPrint("重新编辑");
                              }),
                    ],
                  ),
                const SizedBox(width: 5),
                if (isRight && msg['msgContent']['type'] != 'retraction')
                  CustomPortrait(
                    url: globalData.currentAvatarUrl ?? '',
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
                mainAxisAlignment: msg['msgContent']['type'] == 'retraction'
                    ? MainAxisAlignment.center
                    : isRight
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isRight && msg['msgContent']['type'] != 'retraction')
                    CustomPortrait(
                      url: chatPortrait ?? '',
                      size: 38.7,
                    ),
                  const SizedBox(width: 5),
                  // getComponentByType(msg['msgContent']['type'], isRight),
                  _getComponentByType(msg, isRight),
                  if (msg['msgContent']['type'] == 'retraction' &&
                      isRight &&
                      msg['msgContent']['ext'] != null &&
                      msg['msgContent']['ext'] == 'text')
                    const SizedBox(width: 1),
                  if (msg['msgContent']['type'] == 'retraction' &&
                      isRight &&
                      msg['msgContent']['ext'] != null &&
                      msg['msgContent']['ext'] == 'text')
                    Column(
                      children: [
                        const SizedBox(height: 1.2),
                        CustomTextButton('重新编辑', fontSize: 12, onTap: () {
                          debugPrint("重新编辑");
                          reEdit?.call();
                        }),
                      ],
                    ),
                  const SizedBox(width: 5),
                  if (isRight && msg['msgContent']['type'] != 'retraction')
                    CustomPortrait(
                      url: globalData.currentAvatarUrl ?? '',
                      size: 38.7,
                    ),
                ],
              )),
        const SizedBox(height: 15),
      ],
    );
  }

  String _handlerGroupDisplayName() {
    // 检查 member 是否为 null
    if (member == null) return msg['msgContent']?['formUserName'] ?? '';
    // 尝试从 member 中获取优先属性
    try {
      return member?.containsKey('groupName') == true &&
          member!['groupName'] != null
          ? member!['groupName']!
          : member?.containsKey('remark') == true && member!['remark'] != null
          ? member!['remark']!
          : member!['name'] ?? '';
    } catch (e) {
      // 异常处理：返回一个空字符串或增加日志记录
      debugPrint('Error fetching display name: $e');
      return '';
    }
  }

  List<PopMenuItemModel> _menuItems(String type, {bool? toText = true}) => [
    if (type == 'text')
      PopMenuItemModel(
        title: '复制',
        icon: Icons.content_copy,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapCopy?.call(data);
        },
      ),
    if (type == 'voice' && toText!)
      PopMenuItemModel(
        title: '转文字',
        icon: Icons.text_fields,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapVoiceToText?.call(data);
        },
      ),
    if (type == 'voice' && !toText!)
      PopMenuItemModel(
        title: '隐藏',
        icon: Icons.high_quality,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapVoiceHiddenText?.call(data);
        },
      ),
    if (type != 'call')
      PopMenuItemModel(
          title: '转发',
          icon: Icons.send_sharp,
          callback: (data) {
            debugPrint("data: ${data.toString()}");
            onTapRepost?.call(data);
          }),
    PopMenuItemModel(
        title: '收藏',
        icon: Icons.collections,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapFavorite?.call(data);
        }),
    PopMenuItemModel(
        title: '删除',
        icon: Icons.delete,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapDelete?.call(data);
        }),
    if (msg['fromId'] == globalData.currentUserId)
      PopMenuItemModel(
          title: '撤回',
          icon: Icons.reply_all,
          callback: (data) {
            debugPrint("data: ${data.toString()}");
            onTapRetract?.call(data);
          }),
    PopMenuItemModel(
        title: '多选',
        icon: Icons.playlist_add_check,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapMultipleChoice?.call(data);
        }),
    PopMenuItemModel(
        title: '引用',
        icon: Icons.format_quote,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapCite?.call(data);
        }),
    PopMenuItemModel(
        title: '提醒',
        icon: Icons.add_alert,
        callback: (data) {
          debugPrint("data: ${data.toString()}");
          onTapRemind?.call(data);
        }),
    PopMenuItemModel(
        title: '搜一搜',
        icon: Icons.search,
        callback: (data) {
          debugPrint("data: ${data.toString()} ");
          onTapSearch?.call(data);
        }),
  ];

  Widget _getComponentByType(Map<String, dynamic> msg, bool isRight) {
    String? type = msg['msgContent']['type'];
    Map<String, dynamic>? content;
    if (type == 'voice') content = jsonDecode(msg['msgContent']['content']);
    final messageMap = {
      'text': (String? username) => TextMessage(value: msg, isRight: isRight),
      'file': (String? username) => FileMessage(value: msg, isRight: isRight),
      'img': (String? username) => ImageMessage(value: msg, isRight: isRight),
      'retraction': (String? username) => RetractionMessage(
        isRight: isRight,
        userName: username,
      ),
      'voice': (String? username) => VoiceMessage(value: msg, isRight: isRight),
      'call': (String? username) => CallMessage(value: msg, isRight: isRight),
    };

    if (messageMap.containsKey(type)) {
      final messageWidget =
      messageMap[type]!(msg['msgContent']['formUserName']);
      return type == 'retraction'
          ? messageWidget
          : QuickPopUpMenu(
        showArrow: true,
        // useGridView: false,
        useGridView: true,
        darkMode: true,
        pressType: PressType.longPress,
        menuItems: _menuItems(type!,
            toText: content != null
                ? content['text'] == null || content['text'].isEmpty
                : false),
        dataObj: messageWidget,
        child: GestureDetector(
          onTap: onTapMsg,
          child: messageWidget,
        ),
      );
    } else
      // 异常处理
      return const Text('暂不支持该消息类型');
  }
}

