import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';

// 用户聊天信息模型
class ChatInfo {
  final String avatar;
  final String name;
  final String lastMessage;
  final String lastTime;
  final int unreadCount;
  bool isTop;

  ChatInfo({
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
    this.isTop = false,
  });
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<ChatInfo> _chatList = [
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "张三",
      lastMessage: "今天晚上有空吗？",
      lastTime: "12:30",
      unreadCount: 2,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "李四",
      lastMessage: "项目进展如何？",
      lastTime: "11:20",
      unreadCount: 0,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "王五",
      lastMessage: "好的，收到了",
      lastTime: "昨天",
      unreadCount: 1,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "张三",
      lastMessage: "今天晚上有空吗？",
      lastTime: "12:30",
      unreadCount: 2,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "李四",
      lastMessage: "项目进展如何？",
      lastTime: "11:20",
      unreadCount: 0,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "王五",
      lastMessage: "好的，收到了",
      lastTime: "昨天",
      unreadCount: 1,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "张三",
      lastMessage: "今天晚上有空吗？",
      lastTime: "12:30",
      unreadCount: 2,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "李四",
      lastMessage: "项目进展如何？",
      lastTime: "11:20",
      unreadCount: 0,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "王五",
      lastMessage: "好的，收到了",
      lastTime: "昨天",
      unreadCount: 1,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "张三",
      lastMessage: "今天晚上有空吗？",
      lastTime: "12:30",
      unreadCount: 2,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "李四",
      lastMessage: "项目进展如何？",
      lastTime: "11:20",
      unreadCount: 0,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "王五",
      lastMessage: "好的，收到了",
      lastTime: "昨天",
      unreadCount: 1,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "张三",
      lastMessage: "今天晚上有空吗？",
      lastTime: "12:30",
      unreadCount: 2,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "李四",
      lastMessage: "项目进展如何？",
      lastTime: "11:20",
      unreadCount: 0,
      isTop: true,
    ),
    ChatInfo(
      avatar:
          "http://139.196.241.208:9000/linyu/e766ca80-d178-4541-89f7-dd7a1718909d-portrait?t=17297769549531",
      name: "王五",
      lastMessage: "好的，收到了",
      lastTime: "昨天",
      unreadCount: 1,
    ),
  ];

  void _toggleTopStatus(int index) {
    setState(() {
      _chatList[index].isTop = !_chatList[index].isTop;
      _sortChatList();
    });
  }

  void _deleteChat(int index) {
    setState(() {
      _chatList.removeAt(index);
    });
  }

  void _sortChatList() {
    _chatList.sort((a, b) {
      if (a.isTop && !b.isTop) return -1;
      if (!a.isTop && b.isTop) return 1;
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChatInfo> topList = _chatList.where((chat) => chat.isTop).toList();
    List<ChatInfo> normalList = _chatList.where((chat) => !chat.isTop).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('聊天列表'),
        backgroundColor: const Color(0xFFF9FBFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 32),
            onPressed: () {
              print('图标按钮被点击');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: Column(
          children: [
            CustomSearchBox(
              isCentered: false,
              onChanged: (value) {
                print(value);
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  if (topList.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "置顶",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C9BFF),
                        ),
                      ),
                    ),
                    ...topList.map((chat) =>
                        _buildChatItem(chat, _chatList.indexOf(chat))),
                  ],
                  if (normalList.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "其他",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C9BFF),
                        ),
                      ),
                    ),
                    ...normalList.map((chat) =>
                        _buildChatItem(chat, _chatList.indexOf(chat))),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatInfo chat, int index) {
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // extentRatio: chat.isTop ? 0.625 : 0.5,
        children: [
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => _toggleTopStatus(index),
            backgroundColor: Color(0xFF4C9BFF),
            foregroundColor: Colors.white,
            icon: chat.isTop ? Icons.push_pin_outlined : Icons.push_pin,
            label: chat.isTop ? '取消置顶' : '置顶',
            // flex: chat.isTop ? 3 : 2,
          ),
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => _deleteChat(index),
            backgroundColor: const Color(0xFFFF4C4C),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
            // flex: 2,
          ),
        ],
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: chat.avatar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffffffff),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: Image.asset('assets/images/default-portrait.jpeg'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            chat.lastTime,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF4C4C),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
