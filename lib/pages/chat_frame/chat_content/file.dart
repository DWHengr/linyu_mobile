import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/String.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class FileMessage extends StatelessThemeWidget {
  final dynamic value;
  final bool isRight;

  const FileMessage({
    super.key,
    required this.value,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    dynamic content = jsonDecode(value['msgContent']['content']);
    return Container(
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRight ? theme.primaryColor : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(Get.context!).size.width * 0.6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  maxLines: 2,
                  content['name'],
                  style: TextStyle(
                      color: isRight ? Colors.white : null,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 2),
                Text(
                  StringUtil.formatSize(content['size']),
                  style: TextStyle(
                      color: isRight ? Colors.white : null, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                isRight
                    ? 'assets/images/file-white.png'
                    : 'assets/images/file-${theme.themeMode}.png',
                width: 50,
              ),
              Transform.translate(
                offset: const Offset(-2, 2),
                child: Text(
                  content['type'].toUpperCase(),
                  style: TextStyle(
                      color: isRight ? theme.primaryColor : Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
