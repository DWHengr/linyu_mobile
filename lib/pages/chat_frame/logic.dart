import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/msg_api.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/web_socket.dart';

class ChatFrameLogic extends GetxController {
  final _msgApi = MsgApi();
  final _chatListApi = ChatListApi();
  final _wsManager = WebSocketUtil();
  final TextEditingController msgContentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late List<dynamic> msgList = [];
  late String targetId = '';
  late dynamic chatInfo = {targetId: ''};
  late RxBool isSend = false.obs;

  // 分页相关
  int num = 20;
  int index = 0;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void onInit() {
    chatInfo = Get.arguments['chatInfo'] ?? '';
    targetId = chatInfo['fromId'];
    super.onInit();
    onGetMsgRecode();
    eventListen();
    onRead();

    // 添加滚动监听
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.position.pixels ==
            scrollController.position.minScrollExtent) {
          loadMore();
        }
      }
    });
  }

  void eventListen() {
    // 监听消息
    _wsManager.eventStream.listen((event) {
      if (event['type'] == 'on-receive-msg') {
        if (event['content']['fromId'] == targetId) {
          msgListAddMsg(event['content']);
        }
      }
    });
  }

  Future<void> onGetMsgRecode() async {
    isLoading = true;
    update([const Key('chat_frame')]);
    try {
      final res = await _msgApi.record(targetId, index, num);
      if (res['code'] == 0) {
        msgList = res['data'];
        index += msgList.length;
        hasMore = res['data'].length >= 0;
        update([const Key('chat_frame')]);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollBottom();
        });
      }
    } finally {
      isLoading = false;
      update([const Key('chat_frame')]);
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    update([const Key('chat_frame')]);

    try {
      final res = await _msgApi.record(targetId, index, num);
      if (res['code'] == 0) {
        if (res['data'].isEmpty) {
          hasMore = false;
        } else {
          final double previousScrollOffset = scrollController.position.pixels;
          final double previousMaxScrollExtent =
              scrollController.position.maxScrollExtent;

          msgList.insertAll(0, res['data']);
          index = msgList.length;
          hasMore = res['data'].length >= 0;

          SchedulerBinding.instance.addPostFrameCallback((_) {
            final double newMaxScrollExtent =
                scrollController.position.maxScrollExtent;
            final double newOffset = previousScrollOffset +
                (newMaxScrollExtent - previousMaxScrollExtent) -
                10;
            scrollController.animateTo(
              newOffset,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
            );
          });
        }
      }
    } finally {
      isLoading = false;
      update([const Key('chat_frame')]);
    }
  }

  void scrollBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void toDetailsPage() {
    if (chatInfo['type'] == 'group') {
      Get.toNamed('/chat_group_info', arguments: {'chatGroupId': targetId});
    } else {
      Get.toNamed('/friend_info', arguments: {'friendId': targetId});
    }
  }

  void sendTextMsg() async {
    if (StringUtil.isNullOrEmpty(msgContentController.text)) return;
    dynamic msg = {
      'toUserId': targetId,
      'source': chatInfo['type'],
      'msgContent': {'type': "text", 'content': msgContentController.text}
    };
    _msgApi.send(msg).then((res) {
      if (res['code'] == 0) {
        msgContentController.text = '';
        msgListAddMsg(res['data']);
        onRead();
      }
    });
  }

  void msgListAddMsg(msg) {
    msgList.add(msg);
    index = msgList.length;
    update([const Key('chat_frame')]);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollBottom();
    });
  }

  void onRead() {
    _chatListApi.read(targetId);
  }

  @override
  void onClose() {
    super.onClose();
    msgContentController.dispose();
    scrollController.dispose();
  }
}
