import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class TextMessage extends StatelessThemeWidget {
  final dynamic value;
  final bool isRight;

  const TextMessage({
    super.key,
    required this.value,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: isRight ? theme.primaryColor : Colors.white,
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
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(Get.context!).size.width * 0.7,
    ),
    child: Text(
      value['msgContent']['content'],
      style: TextStyle(color: isRight ? Colors.white : null, fontSize: 14),
    ),
  );
}
