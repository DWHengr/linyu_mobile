import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart' show Slidable;
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_badge/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_search_box/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';
import 'package:linyu_mobile/utils/linyu_msg.dart';
import 'logic.dart';

// todo: 功能待实现
class ReForwardPage extends CustomView<ReForwardLogic> {
  ReForwardPage({super.key});

  Widget _buildSearchItem(dynamic friend, String id) => Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () => controller.onTapSearchFriend(friend),
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

  Widget _buildChatItem(dynamic chat, String id) => Slidable(
        key: ValueKey(id),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: InkWell(
            onTap: () => controller.onTapUser(chat),
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
                    CustomPortrait(url: chat['portrait']),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    StringUtil.isNotNullOrEmpty(chat['remark'])
                                        ? chat['remark']
                                        : chat['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (chat['type'] == 'group')
                                    const CustomBadge(text: '群'),
                                ],
                              ),
                              Text(
                                DateUtil.formatTime(chat['updateTime']),
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
                                  LinyuMsgUtil.getMsgContent(
                                      chat['lastMsgContent']),
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

  @override
  Widget buildView(BuildContext context) => GestureDetector(
        onTap: () => controller.focusNode.unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FBFF),
          appBar: AppBar(
            leading:
                CustomTextButton('取消', onTap: () => Get.back(), fontSize: 14),
            centerTitle: true,
            title: const AppBarTitle('发送给'),
            backgroundColor: const Color(0xFFF9FBFF),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            child: Column(
              children: [
                CustomSearchBox(
                  focusNode: controller.focusNode,
                  textEditingController: controller.searchBoxController,
                  isCentered: false,
                  onChanged: (value) => controller.onSearchFriend(value),
                ),
                if (controller.searchList.isNotEmpty ||
                    controller.otherList.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.onGetChatList();
                        return Future.delayed(
                            const Duration(milliseconds: 700));
                      },
                      color: theme.primaryColor,
                      child: ListView(
                        children: [
                          if (controller.searchList.isNotEmpty &&
                              controller.searchBoxController.text
                                  .trim()
                                  .isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                          if (controller.otherList.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "全部",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            ...controller.otherList.map(
                                (chat) => _buildChatItem(chat, chat['id'])),
                          ],
                        ],
                      ),
                    ),
                  ),
                if (controller.searchList.isEmpty &&
                    controller.otherList.isEmpty)
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
                            '暂无聊天记录~',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
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
