import 'package:flutter/material.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomTextButton extends StatelessThemeWidget {
  final String value;
  final GestureTapCallback onTap;
  final Color? textColor;
  final double fontSize;

  const CustomTextButton(
    this.value, {
    super.key,
    required this.onTap,
    this.fontSize = 12,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor ?? theme.primaryColor,
        ),
      ),
    );
  }
}
