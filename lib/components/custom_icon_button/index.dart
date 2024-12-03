import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

class CustomIconButton extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final double? radius;
  final Function() onTap;
  final String? text;

  const CustomIconButton({
    super.key,
    this.width = 40,
    this.height = 40,
    this.iconSize = 36,
    this.color,
    required this.onTap,
    this.iconColor,
    required this.icon,
    this.text,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomMaterialButton(
          color: color ?? const Color(0xFFE3ECFF),
          borderRadius: radius ?? width / 2,
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.black38,
            ),
          ),
        ),
        if (text != null) ...[
          const SizedBox(height: 4),
          SizedBox(
            width: width + 10,
            child: Center(
              child: Text(
                text!,
                style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
