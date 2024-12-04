import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:linyu_mobile/utils/getx_config/config.dart';

class SystemMessage extends StatelessThemeWidget {
  final dynamic value;

  const SystemMessage({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    List<dynamic> systemMsgList = jsonDecode(value['content']);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: systemMsgList.map((msg) {
          final isEmphasize = msg['isEmphasize'] as bool? ?? false;
          final content = msg['content'] as String? ?? '';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                color: isEmphasize ? theme.primaryColor : Colors.black,
                fontWeight: isEmphasize ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
