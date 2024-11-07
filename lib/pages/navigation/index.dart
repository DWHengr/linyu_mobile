import 'package:flutter/material.dart';
import 'package:linyu_mobile/pages/chat_list/index.dart';
import 'package:linyu_mobile/pages/mine/mine.dart';
import 'package:linyu_mobile/pages/talk/index.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _selectedIcons = [
    'assets/images/chat.png',
    'assets/images/user.png',
    'assets/images/talk.png',
    'assets/images/mine.png',
  ];

  final List<String> _unselectedIcons = [
    'assets/images/chat-empty.png',
    'assets/images/user-empty.png',
    'assets/images/talk-empty.png',
    'assets/images/mine-empty.png',
  ];

  final List<String> _name = [
    '消息',
    '通讯',
    '说说',
    '我的',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ChatListPage(),
          Center(child: Text('通讯列表', style: TextStyle(fontSize: 24))),
          Talk(),
          Mine(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        backgroundColor: const Color(0xFFEDF2F9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(_unselectedIcons.length, (index) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == index
                  ? _selectedIcons[index]
                  : _unselectedIcons[index],
              width: 26,
              height: 26,
            ),
            label: _name[index],
          );
        }),
      ),
    );
  }
}
