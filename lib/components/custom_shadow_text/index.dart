import 'package:flutter/cupertino.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomShadowText extends StatelessThemeWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double shadowTop;

  const CustomShadowText(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.shadowTop = 13,
      this.fontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: shadowTop,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    theme.primaryColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10), // 圆角
              ),
              child: Opacity(
                opacity: 0,
                child: Text(
                  text,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
        ),
        Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
