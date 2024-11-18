import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_drop_menu/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FriendInformationPage extends CustomWidget<FriendInformationLogic> {
  FriendInformationPage({super.key});

  List<Widget> _buildHeader(BuildContext context, bool innerBoxIsScrolled) => [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Obx(
              () => Opacity(
                opacity: controller.opacity.value,
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    controller.friendRemark.isNotEmpty
                        ? controller.friendRemark
                        : controller.friendName,
                    style: const TextStyle(
                      color: Color(0xFF07000a),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            centerTitle: true,
            background: Row(
              children: [
                const SizedBox(width: 18.6),
                Container(
                  margin: const EdgeInsets.only(top: 80, right: 10),
                  child: CustomPortrait(
                    url: controller.friendPortrait,
                    size: 150,
                    radius: 75,
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  margin: const EdgeInsets.only(top: 80, left: 10),
                  // color: Colors.green,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.friendName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 43.6,
                          ),
                        ),
                        const SizedBox(height: 26.3),
                        Text(
                          "账号：${controller.friendAccount}",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF989898),
                            fontSize: 16.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          expandedHeight: Size.fromHeight(
                  MediaQuery.of(context).size.width * 10.7 / 16.0 -
                      MediaQueryData.fromView(WidgetsBinding
                              .instance.platformDispatcher.views.first)
                          .padding
                          .top +
                      30)
              .height,
          floating: false,
          pinned: true,
          snap: false,
          elevation: 0.1,
          backgroundColor: const Color(0xFFfaf7ff),
          actions: [
            IconButton(
              onPressed: controller.setConcern,
              icon: controller.isConcern
                  ? const Icon(
                      Icons.favorite,
                      size: 32,
                      color: Color(0xFFf8a1d2),
                    )
                  : const Icon(
                      Icons.favorite_border,
                      size: 32,
                      color: Color(0xFF989898),
                    ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, size: 32),
              offset: const Offset(0, 46.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: const Color(0xFFFFFFFF),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem(
                  value: 1,
                  height: 40,
                  onTap: controller.deleteFriend,
                  child: const SizedBox(
                    width: 85,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(Icons.person_add, size: 20),
                        SizedBox(width: 12),
                        Text('删除好友', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ];

  //说一说图片浏览
  Widget _buildImageGrid(List<dynamic> imageUrls, String userId) =>
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1.0,
        ),
        itemCount: imageUrls.isNotEmpty ? 5 : 0,
        itemBuilder: (context, index) =>
            _buildTalkImage(imageUrls[index], userId),
      );

  Widget _buildTalkImage(String imageStr, String userId) => Container(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder<String>(
          future: controller.getImg(imageStr, userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CachedNetworkImage(
                imageUrl: snapshot.data ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffffffff),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/empty-bg.png'),
              );
            } else {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffffffff),
                    strokeWidth: 2,
                  ),
                ),
              );
            }
          },
        ),
      );

  Widget _buildBody(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFfaf7ff),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.3),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: const Color(0xFF07000a),
                ),
                //性别 年龄 生日
                Row(
                  children: [
                    const SizedBox(width: 12.3),
                    Icon(
                        controller.friendGender == "男"
                            ? Icons.male
                            : Icons.female,
                        color: controller.friendGender == "男"
                            ? Colors.blue
                            : Colors.pink,
                        size: 25),
                    const SizedBox(width: 8.3),
                    Text(
                      controller.friendGender,
                      style: const TextStyle(
                        color: Color(0xFF07000a),
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFF07000a),
                      margin: const EdgeInsets.symmetric(horizontal: 4.3),
                    ),
                    Text(
                      "${controller.friendAge.toString()}岁",
                      style: const TextStyle(
                        color: Color(0xFF07000a),
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFF07000a),
                      margin: const EdgeInsets.symmetric(horizontal: 4.3),
                    ),
                    Text(
                      controller.friendBirthday,
                      style: const TextStyle(
                        color: Color(0xFF07000a),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                //备注
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/edit.png',
                      height: 18.6,
                      width: 18.6,
                    ),
                    const SizedBox(width: 8.3),
                    const Text(
                      '备注：',
                      style:
                          TextStyle(color: Color(0xFF07000a), fontSize: 18.6),
                    ),
                    SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.commentController,
                              focusNode: controller.commentFocus,
                              onSubmitted: (v) =>
                                  controller.setRemark(v, context),
                              decoration: InputDecoration(
                                hintText: controller.friendRemark.isEmpty
                                    ? '设置备注'
                                    : controller.friendRemark,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                //分组
                Row(
                  children: [
                    Image.asset(
                      'assets/images/group.png',
                      height: 18.6,
                      width: 18.6,
                    ),
                    const SizedBox(width: 8.3),
                    const Text(
                      '分组：',
                      style:
                          TextStyle(color: Color(0xFF07000a), fontSize: 18.6),
                    ),
                    controller.friendGroup.isNotEmpty
                        ? Container(
                            key: const Key('group_drop_menu'),
                            color: Colors.transparent,
                            width: 75.3,
                            alignment: Alignment.centerLeft,
                            child: DropMenuWidget(
                              key: const Key('group_drop_menu_widget'),
                              backGroundColor: const Color(0xFFfbf4ff),
                              selectTextStyle: const TextStyle(
                                color: Color(0xFF07000a),
                              ),
                              textColor: const Color(0xFF07000a),
                              normalTextStyle: const TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 12.0,
                              ),
                              leading: const Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(''),
                              ),
                              data: controller.groupList,
                              selectCallBack: controller.setGroup,
                              offset: const Offset(0, 40),
                              selectedValue: controller.friendGroup != "0"
                                  ? controller.friendGroup
                                  : null,
                            ),
                          )
                        : Container(),
                  ],
                ),
                const SizedBox(height: 16.3),
                //好友签名
                Row(
                  children: [
                    Image.asset(
                      'assets/images/signature.png',
                      height: 18.6,
                      width: 18.6,
                    ),
                    const SizedBox(width: 8.3),
                    const Text(
                      '签名：',
                      style:
                          TextStyle(color: Color(0xFF07000a), fontSize: 18.6),
                    ),
                    Expanded(
                      child: Text(
                        controller.friendSignature,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF07000a),
                          fontSize: 16.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.3),
                //说一说
                Row(
                  children: [
                    Image.asset(
                      'assets/images/icon-circle-of-friends.png',
                      height: 18.6,
                      width: 18.6,
                      color: const Color(0xFF07000a),
                    ),
                    const SizedBox(width: 8.3),
                    const Text(
                      '说一说：',
                      style:
                          TextStyle(color: Color(0xFF07000a), fontSize: 18.6),
                    ),
                    Text(
                      controller.talkContent['text'],
                      style: const TextStyle(
                        color: Color(0xFF07000a),
                        fontSize: 16.3,
                      ),
                    ),
                  ],
                ),
                _buildImageGrid(
                    controller.talkContent['img'], controller.friendId),
                const SizedBox(height: 16.3),
              ],
            ),
          ),
        ),
      );

  @override
  Widget buildWidget(BuildContext context) => GestureDetector(
        onTap: () =>
            controller.setRemark(controller.commentController.text, context),
        child: Scaffold(
          body: NestedScrollView(
            controller: controller.scrollController,
            headerSliverBuilder: _buildHeader,
            body: _buildBody(context),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 19.3),
              CustomButton(
                text: '发消息',
                onTap: () {},
                width: 150,
              ),
              const SizedBox(width: 12.3),
              CustomButton(
                text: '视频聊天',
                onTap: () {},
                width: 150,
              ),
            ],
          ),
        ),
      );
}
