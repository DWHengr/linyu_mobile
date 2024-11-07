import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/utils/date.dart';

final _chatListApi = ChatListApi();
final _friendApi = FriendApi();

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<dynamic> _topList = [];
  late List<dynamic> _otherList = [];
  late List<dynamic> _searchList = [];

  @override
  void initState() {
    super.initState();
    _onGetChatList();
  }

  void _onGetChatList() {
    _chatListApi.list().then((res) {
      if (res['code'] == 0) {
        setState(() {
          _topList = res['data']['tops'];
          _otherList = res['data']['others'];
        });
      }
    });
  }

  void _onTopStatus(String id, bool isTop) {
    _chatListApi.top(id, !isTop).then((res) {
      if (res['code'] == 0) {
        _onGetChatList();
      }
    });
  }

  void _onDeleteChatList(String id) {
    _chatListApi.delete(id).then((res) {
      if (res['code'] == 0) {
        _onGetChatList();
      }
    });
  }

  void _onSearchFriend(String friendInfo) {
    if (friendInfo == null || friendInfo.trim() == '') {
      setState(() {
        _searchList = [];
      });
      return;
    }
    _friendApi.search(friendInfo).then((res) {
      if (res['code'] == 0) {
        setState(() {
          _searchList = res['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('聊天列表'),
        backgroundColor: const Color(0xFFF9FBFF),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add, size: 32),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: const Color(0xFFFFFFFF),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                height: 40,
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconData(0xe61e, fontFamily: 'IconFont'), size: 20),
                    SizedBox(width: 12),
                    Text('扫一扫', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              _buildPopupDivider(),
              PopupMenuItem(
                value: 1,
                height: 40,
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, size: 20),
                    SizedBox(width: 12),
                    Text('添加好友', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              _buildPopupDivider(),
              PopupMenuItem(
                value: 2,
                height: 40,
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group_add, size: 20),
                    SizedBox(width: 12),
                    Text('创建群聊', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
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
                _onSearchFriend(value);
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _onGetChatList();
                  return Future.delayed(const Duration(milliseconds: 700));
                },
                child: ListView(
                  children: [
                    if (_searchList.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "搜索结果",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C9BFF),
                          ),
                        ),
                      ),
                      ..._searchList.map((friend) =>
                          _buildSearchItem(friend, friend['friendId'])),
                    ],
                    if (_topList.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "置顶",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C9BFF),
                          ),
                        ),
                      ),
                      ..._topList
                          .map((chat) => _buildChatItem(chat, chat['id'])),
                    ],
                    if (_otherList.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "全部",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C9BFF),
                          ),
                        ),
                      ),
                      ..._otherList
                          .map((chat) => _buildChatItem(chat, chat['id'])),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(dynamic chat, String id) {
    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // extentRatio: chat.isTop ? 0.625 : 0.5,
        children: [
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => _onTopStatus(id, chat['isTop']),
            backgroundColor: const Color(0xFF4C9BFF),
            foregroundColor: Colors.white,
            icon: chat['isTop'] ? Icons.push_pin_outlined : Icons.push_pin,
            label: chat['isTop'] ? '取消置顶' : '置顶',
            // flex: chat.isTop ? 3 : 2,
          ),
          SlidableAction(
            padding: const EdgeInsets.all(0),
            onPressed: (context) => _onDeleteChatList(id),
            backgroundColor: const Color(0xFFFF4C4C),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
            // flex: 2,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // 添加点击事件
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100]!,
                  width: 1,
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
                      imageUrl: chat['portrait'],
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
                        child:
                            Image.asset('assets/images/default-portrait.jpeg'),
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
                              chat['remark'] ?? chat['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateUtil.formatTime(chat['createTime']),
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
                                chat['lastMsgContent']['content'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chat['unreadNum'] > 0)
                              Container(
                                width: 16,
                                height: 16,
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF4C4C),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    chat['unreadNum'] < 99
                                        ? chat['unreadNum'].toString()
                                        : '99',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
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
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuEntry<int> _buildPopupDivider() {
    return PopupMenuItem<int>(
      enabled: false,
      height: 1,
      child: Container(
        height: 1,
        padding: const EdgeInsets.all(0),
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildSearchItem(dynamic friend, String id) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // 添加点击事件
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
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
                    imageUrl: friend['portrait'],
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
                        children: [
                          Text(
                            friend['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (friend['remark']?.toString().trim() != '')
                            Text(
                              '(${friend['remark']})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
