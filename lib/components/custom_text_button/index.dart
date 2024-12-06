import 'package:flutter/material.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomTextButton extends StatelessThemeWidget {
  final String value;
  final GestureTapCallback onTap;
  final Color? textColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomTextButton(
    this.value, {
    super.key,
    required this.onTap,
    this.fontSize = 12,
    this.padding,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor ?? theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
