import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linyu_mobile/utils/date.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CallMessage extends StatelessThemeWidget {
  final dynamic value;
  final bool isRight;

  const CallMessage({
    super.key,
    required this.value,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    final content = jsonDecode(value['msgContent']['content']);
    final type = content?['type'];
    final time = content?['time'] ?? 0;

    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        color: isRight ? theme.primaryColor : Colors.white,
        // borderRadius: BorderRadius.circular(5),
        borderRadius: isRight
            ? const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )
            : const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              type == 'audio' ? Icons.phone : Icons.videocam,
              size: 20,
              color: isRight ? Colors.white : Colors.black,
            ),
          ),
          Text(
            time > 0 ? "通话时长 ${DateUtil.formatTimingTime(time)}" : "通话未接通",
            style: TextStyle(
              color: isRight ? Colors.white : null,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
