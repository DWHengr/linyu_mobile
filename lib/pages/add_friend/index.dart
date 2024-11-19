import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/pages/add_friend/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class AddFriendPage extends CustomWidgetNew<AddFriendLogic> {
  AddFriendPage({super.key});

  Widget _buildSearchItem(dynamic friend, [String? id]) => Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: ()=>controller.toFriendDetail(friend),
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
                  CustomButton(
                    text: '添加',
                    onTap: ()=>controller.goApplyFriend(friend),
                    width: 40.2,
                    height: 27.4,
                    textSize: 12,
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  //添加好友页面
  @override
  Widget buildWidget(BuildContext context)
    => Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(title: const Text('好友搜索'), centerTitle: true, actions: [
        //取消按钮
        TextButton(
          child: const Text('取消'),
          onPressed: () => Get.back(),
        ),
      ]),
      body: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              CustomSearchBox(
                height: 30,
                hintText: '账号/手机号/邮箱',
                onChanged: controller.onSearchFriend,
              ),
              if (controller.searchList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        Future.delayed(const Duration(milliseconds: 700)),
                    color: theme.primaryColor,
                    child: ListView(
                      children: [
                        if (controller.searchList.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "搜索结果",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          ...controller.searchList.map((friend) =>
                              _buildSearchItem(friend, friend['friendId'])),
                        ],
                      ],
                    ),
                  ),
                ),
              if (controller.searchList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty-bg.png',
                          width: 100,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '暂无搜索结果',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

}
