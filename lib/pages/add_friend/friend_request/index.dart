import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_shadow_text/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/add_friend/friend_request/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FriendRequestPage extends CustomView<FriendRequestLogic> {
  FriendRequestPage({super.key});

  //申请好友页面
  @override
  Widget buildView(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF9FBFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9FBFF),
          title: const AppBarTitle('申请信息'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
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
                                  url: controller.friendPortrait ?? '',
                                  size: 70,
                                  radius: 35),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomShadowText(
                                          text: controller.friendName ?? ''),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: "填写申请信息",
                        labelTextColor: const Color(0xFF99999a),
                        controller: controller.applyFriendController,
                        inputLimit: 100,
                        onChanged: controller.applyFriendTextChanged,
                        maxLines: 4,
                        suffix: Text('${controller.applyFriendLength}/100'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomButton(
                  text: '发送',
                  onTap: controller.applyFriend,
                ),
              ),
            ],
          ),
        ),
      );
}
