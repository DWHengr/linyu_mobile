import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/pages/login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _userApi = UserApi();

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<Mine> {
  late dynamic currentUserInfo = {};

  @override
  void initState() {
    super.initState();
    _onGetCurrentUserInfo();
  }

  void _onGetCurrentUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserInfo['name'] = prefs.getString('username');
      currentUserInfo['portrait'] = prefs.getString('portrait');
      currentUserInfo['account'] = prefs.getString('account');
    });
  }

  void _handlerLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDFF4FF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: CachedNetworkImage(
                      imageUrl: currentUserInfo['portrait'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffffffff),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child:
                            Image.asset('assets/images/default-portrait.jpeg'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 13,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 15,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0x1A4C9BFF),
                                          Color(0xE64C9BFF)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10), // 圆角
                                    ),
                                    child: Opacity(
                                      opacity: 0,
                                      child: Text(
                                        currentUserInfo['name'] ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                currentUserInfo['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10), // 间距
                          Text(
                            '账号：${currentUserInfo['account'] ?? ''}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const Icon(IconData(0xe615, fontFamily: 'IconFont'),
                          size: 45)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _primarySelectButton('我的说说', 'mine-talk.png', () {}),
                  const SizedBox(height: 2),
                  _primarySelectButton('系统通知', 'mine-notify.png', () {}),
                  const SizedBox(height: 30),
                  _minorSelectButton('修改密码', 'mine-password.png', () {}),
                  const SizedBox(height: 2),
                  _minorSelectButton('关于我们', 'mine-about.png', () {}),
                  const SizedBox(height: 2),
                  _minorSelectButton('设置', 'mine-set.png', () {}),
                  const SizedBox(height: 30),
                  _leastSelectButton('切换账号', () {}),
                  const SizedBox(height: 2),
                  _leastSelectButton(
                      '退出', color: const Color(0xFFFFF4C4C), _handlerLogout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primarySelectButton(String text, String iconStr, Function() onTap) {
    return CustomMaterialButton(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            Image.asset('assets/images/$iconStr', width: 40),
          ],
        ),
      ),
    );
  }

  Widget _minorSelectButton(String text, String iconStr, Function() onTap) {
    return CustomMaterialButton(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/$iconStr', width: 20),
                const SizedBox(width: 1),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14, height: 1),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: 40, // Set your desired width
                height: 40, // Set your desired height
                child: Icon(
                  const IconData(0xe61f, fontFamily: 'IconFont'),
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leastSelectButton(String text, Function() onTap, {Color? color}) {
    return CustomMaterialButton(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontSize: 14, height: 1, color: color ?? Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
