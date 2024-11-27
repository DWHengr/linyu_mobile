import 'dart:convert';

import 'package:linyu_mobile/utils/date.dart';

class LinyuMsgUtil {
  static String getMsgContent(dynamic msgContent) {
    String contentStr = '';
    try {
      switch (msgContent['type']) {
        case "text":
          contentStr = msgContent['content'];
          break;
        case "file":
          var content = jsonDecode(msgContent['content']);
          contentStr = '[文件] ${content['name']}';
          break;
        case "img":
          contentStr = '[图片]';
          break;
        case "retraction":
          contentStr = '[消息被撤回]';
          break;
        case "voice":
          var content = jsonDecode(msgContent['content']);
          contentStr = '[语音] ${content['time']}';
          break;
        case "call":
          var content = jsonDecode(msgContent['content']);
          contentStr =
              '[通话] ${content['time'] > 0 ? DateUtil.formatTimingTime(content['time']) : "未接通"}';
          break;
        case "system":
          contentStr = '[系统消息]';
          break;
        case "quit":
          contentStr = '[系统消息]';
          break;
      }
    } catch (e) {
      return '';
    }
    return contentStr;
  }
}
