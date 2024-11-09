import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/chat_group_api.dart';
import 'package:linyu_mobile/api/friend_api.dart';
import 'package:linyu_mobile/api/notify_api.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _friendApi = FriendApi();
final _chatGroupApi = ChatGroupApi();
final _notifyApi = NotifyApi();

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<String> tabs = ['我的群聊', '我的好友', '好友通知'];
  int selectedIndex = 1;
  String currentUserId = '';
  List<dynamic> _friendList = [];
  List<dynamic> _chatGroupList = [];
  List<dynamic> _notifyFriendList = [];

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        currentUserId = prefs.getString('userId') ?? '';
      });
    });
  }

  void _onFriendList() {
    _friendApi.list().then((res) {
      if (res['code'] == 0) {
        setState(() {
          _friendList = res['data'];
        });
      }
    });
  }

  void _onChatGroupList() {
    _chatGroupApi.list().then((res) {
      if (res['code'] == 0) {
        setState(() {
          _chatGroupList = res['data'];
        });
      }
    });
  }

  void _onNotifyFriendList() {
    _notifyApi.friendList().then((res) {
      if (res['code'] == 0) {
        setState(() {
          _notifyFriendList = res['data'];
        });
      }
    });
  }

  void handlerTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getContent(String tab) {
    switch (tab) {
      case '好友通知':
        _onNotifyFriendList();
        return ListView(
          children: [
            ..._notifyFriendList.map((notify) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildNotifyFriendItem(notify),
                )),
          ],
        );
      case '我的群聊':
        _onChatGroupList();
        return ListView(
          children: [
            ..._chatGroupList.map(
              (group) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildChatGroupItem(group),
              ),
            ),
          ],
        );
      case '我的好友':
        _onFriendList();
        return ListView(
          children: [
            ..._friendList.map((group) {
              return ExpansionTile(
                iconColor: const Color(0xFF4C9BFF),
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                dense: true,
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                  '${group['name']}（${group['friends'].length}）',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                children: [
                  ...group['friends'].map(
                    (friend) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _buildFriendItem(friend),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildNotifyFriendItem(dynamic notify) {
    bool isFromCurrentUser = currentUserId == notify['fromId'];
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
                CustomPortrait(
                    url: isFromCurrentUser
                        ? notify['toPortrait']
                        : notify['fromPortrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isFromCurrentUser
                                ? notify['toName']
                                : notify['fromName'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          // const SizedBox(width: 2),
                          // Text(
                          //   DateUtil.formatTime(notify['createTime']),
                          //   style: TextStyle(
                          //       fontSize: 12, color: Colors.grey[600]),
                          // )
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getNotifyContentTip(
                            notify['status'], isFromCurrentUser),
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF4C9BFF)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              notify['content'],
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                _getNotifyOperateTip(notify['status'], isFromCurrentUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getNotifyContentTip(status, isFromCurrentUser) {
    if (!isFromCurrentUser) return "请求加你为好友";
    switch (status) {
      case "wait":
        {
          return "正在验证你的请求";
        }
      case "reject":
        {
          return "对方已拒绝你的请求";
        }
      case "agree":
        {
          return "对方已同意你的请求";
        }
    }
    return "";
  }

  Widget _getNotifyOperateTip(status, isFromCurrentUser) {
    if (!isFromCurrentUser && status == "wait") {
      return Row(
        children: [
          CustomTextButton("同意", onTap: () {}),
          const SizedBox(width: 10),
          CustomTextButton(
            "取消",
            onTap: () {},
            textColor: Colors.grey[600],
          ),
          const SizedBox(width: 5),
        ],
      );
    }
    switch (status) {
      case "wait":
        {
          return Text(
            "正在验证",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
      case "reject":
        {
          return Text(
            "对方已拒绝",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
      case "agree":
        {
          return Text(
            "对方已同意",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }
    }
    return const Text("");
  }

  Widget _buildChatGroupItem(dynamic group) {
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
                CustomPortrait(url: group['portrait']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            group['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (group['groupRemark'] != null &&
                              group['groupRemark']?.toString().trim() != '')
                            Text(
                              '(${group['groupRemark']})',
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

  Widget _buildFriendItem(dynamic friend) {
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
                CustomPortrait(url: friend['portrait']),
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
                          if (friend['remark'] != null &&
                              friend['remark']?.toString().trim() != '')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('通讯列表'),
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
              onChanged: (value) {},
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(tabs.length, (index) {
                return Expanded(
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => handlerTabTapped(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(
                          horizontal: index == selectedIndex ? 4.0 : 0.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: index == selectedIndex
                                  ? const Color(0xE64C9BFF)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: index == selectedIndex
                                  ? const Color(0xE64C9BFF)
                                  : Colors.black,
                              fontSize: 16,
                            ),
                            child: Text(tabs[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: getContent(tabs[selectedIndex]),
              ),
            ),
          ],
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
}
