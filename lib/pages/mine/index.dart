import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'logic.dart';

class MinePage extends CustomWidget<MineLogic> {
  MinePage({super.key});

  @override
  void init(BuildContext context) {
    super.init(context);
    controller.init();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.minorColor, const Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/edit_mine');
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: CustomPortrait(
                          url: controller.currentUserInfo['portrait'] ?? '',
                          size: 70,
                          radius: 35),
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
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.primaryColor.withOpacity(0.1),
                                            theme.primaryColor,
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
                                          controller.currentUserInfo['name'] ??
                                              '',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.currentUserInfo['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10), // 间距
                            Text(
                              '账号：${controller.currentUserInfo['account'] ?? ''}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        CustomMaterialButton(
                            child: const Icon(
                                IconData(0xe615, fontFamily: 'IconFont'),
                                size: 45),
                            onTap: () => Get.toNamed('/mine_qr_code'))
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
                    _primarySelectButton('我的说说',
                        'mine-talk-${theme.themeMode.value}.png', () {}),
                    const SizedBox(height: 2),
                    _primarySelectButton('系统通知',
                        'mine-notify-${theme.themeMode.value}.png', () {}),
                    const SizedBox(height: 30),
                    _minorSelectButton('修改密码', 'mine-password.png', () {
                      Get.toNamed('/update_password');
                    }),
                    const SizedBox(height: 2),
                    _minorSelectButton('关于我们', 'mine-about.png', () {
                      Get.toNamed('/about');
                    }),
                    const SizedBox(height: 2),
                    _minorSelectButton('设置', 'mine-set.png', () {}),
                    const SizedBox(height: 30),
                    _leastSelectButton('切换账号', () {}),
                    const SizedBox(height: 2),
                    _leastSelectButton(
                        '退出',
                        color: const Color(0xFFFFF4C4C),
                        controller.handlerLogout),
                  ],
                ),
              ),
            ),
          ],
        ),
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
