import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_image/index.dart';
import 'package:linyu_mobile/pages/mine/system_notify/logic.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class SystemNotifyPage extends CustomWidget<SystemNotifyLogic> {
  SystemNotifyPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        title: const AppBarTitle('系统通知'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF9FBFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...controller.systemNotifyList
                .map((notify) => _buildNotifyItem(notify)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifyItem(notify) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Text(
            DateUtil.formatTime(notify['createTime']),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImage(
                url: notify['content']['img'],
              ),
              const SizedBox(height: 5),
              Text(
                notify['content']['title'] ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                notify['content']['text'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
