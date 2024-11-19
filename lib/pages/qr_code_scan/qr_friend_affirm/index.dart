import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_label_value/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/qr_code_scan/qr_friend_affirm/logic.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class QRFriendAffirmPage extends CustomWidget<QRFriendAffirmLogic> {
  QRFriendAffirmPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('个人资料'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.minorColor, const Color(0xFFFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          child: CustomPortrait(
                              url: controller.result['portrait'] ?? '',
                              size: 70,
                              radius: 35),
                        ),
                        const SizedBox(width: 20),
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
                                                  theme.primaryColor
                                                      .withOpacity(0.1),
                                                  theme.primaryColor,
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // 圆角
                                            ),
                                            child: Opacity(
                                              opacity: 0,
                                              child: Text(
                                                controller.result['name'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        controller.result['name'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10), // 间距
                                  Text(
                                    controller.result['account'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  CustomLabelValue(
                      label: '性别', value: controller.result['sex'] ?? ''),
                  const SizedBox(height: 1),
                  CustomLabelValue(
                      label: '年龄',
                      value:
                          DateUtil.calculateAge(controller.result['birthday'])),
                  const SizedBox(height: 1),
                  CustomLabelValue(
                      label: '生日',
                      value: DateUtil.getYearDayMonth(
                          controller.result['birthday'])),
                  const SizedBox(height: 1),
                  CustomLabelValue(
                      label: '签名', value: controller.result['signature']),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    text: '添加好友',
                    onTap: controller.onAddFriend,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 50),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
