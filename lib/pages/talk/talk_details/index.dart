import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/components/custom_image_group/index.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/talk/talk_details/logic.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class TalkDetailsPage extends CustomWidget<TalkDetailsLogic> {
  TalkDetailsPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle('说说详情'),
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomPortrait(
                                  url:
                                      controller.talkDetails['portrait'] ?? ''),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.talkDetails['remark'] ??
                                        controller.talkDetails['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateUtil.formatTime(
                                        controller.talkDetails['time']),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[800]),
                                  )
                                ],
                              ),
                            ],
                          ),
                          if (controller.currentUserId ==
                              controller.talkDetails['userId'])
                            CustomTextButton('删除',
                                onTap: () =>
                                    controller.handlerDeleteTalkTip(context)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Colors.grey[100]!, width: 1.0),
                            bottom: BorderSide(
                                color: Colors.grey[100]!, width: 1.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.talkDetails['content']['text'] ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                            CustomImageGroup(
                                imagesList: controller.talkDetails['content']
                                        ['img'] ??
                                    [],
                                userId: controller.talkDetails['userId']),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      IntrinsicWidth(
                        child: CustomTextButton(
                            '${controller.isLiked ? '已' : ''}点赞（${controller.talkLikeList.length}）',
                            onTap: controller.onCreateOrDeleteTalkLike),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 2.0,
                        runSpacing: 2.0,
                        children: [
                          ...controller.talkLikeList
                              .map((like) => _buildLikeItem(like)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      IntrinsicWidth(
                        child: CustomTextButton(
                            '评论（${controller.talkCommentList.length}）',
                            onTap: controller.commentFocusNode.requestFocus),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          ...controller.talkCommentList
                              .map((comment) => _buildCommentItem(comment)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
          Container(
            color: const Color(0xFFF9FBFF),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.commentController,
                    focusNode: controller.commentFocusNode,
                    maxLines: 3,
                    minLines: 1,
                    hintTextColor: theme.primaryColor,
                    hintText: '输入评论',
                    vertical: 8,
                  ),
                ),
                const SizedBox(width: 5),
                CustomButton(
                  text: '确定',
                  onTap: controller.onCreateTalkComment,
                  width: 60,
                  textSize: 14,
                  height: 38,
                  // type: 'minor',
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentItem(comment) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomPortrait(
                    url: comment['portrait'] ?? '',
                    size: 30,
                  ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['remark'] ?? comment['name'],
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        DateUtil.formatTime(comment['createTime']),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black38),
                      )
                    ],
                  ),
                ],
              ),
              if (controller.currentUserId == comment['userId'])
                CustomTextButton('删除',
                    onTap: () => controller.onDeleteTalkComment(comment['id'])),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            comment['content'] ?? '',
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget _buildLikeItem(like) {
    return Container(
      height: 26,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1),
        color: theme.searchBarColor,
      ),
      constraints: const BoxConstraints(maxWidth: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPortrait(
            url: like['portrait'] ?? '',
            size: 16,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              like['remark'] ?? like['name'],
              style: const TextStyle(
                  fontSize: 12, overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }
}
