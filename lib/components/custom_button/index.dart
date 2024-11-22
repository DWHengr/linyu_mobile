import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomButton extends StatelessThemeWidget {
  final String text;
  final VoidCallback onTap;
  final String type;
  final double? width;
  final double? height;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomButton(
      {super.key,
      required this.text,
      this.width = 200,
      this.height = 40,
      this.textSize = 16,
      this.type = 'primary',
      this.borderRadius = 10,
      this.padding = const EdgeInsets.all(10),
      required this.onTap});

  Color _getColor(String type) {
    switch (type) {
      case 'primary':
        return theme.primaryColor;
      case 'minor':
        return const Color(0xFFEDF2F9);
      default:
        return theme.primaryColor;
    }
  }

  TextStyle _getTextStyle(String type) {
    switch (type) {
      case 'primary':
        return TextStyle(color: Colors.white, fontSize: textSize);
      case 'minor':
        return TextStyle(color: const Color(0xFF1F1F1F), fontSize: textSize);
      default:
        return TextStyle(color: Colors.white, fontSize: textSize);
    }
  }

  BoxDecoration _getBoxDecoration(String type) {
    switch (type) {
      case 'gradient':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor, theme.boldColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
        );
      default:
        return BoxDecoration(
          color: _getColor(type),
          borderRadius: BorderRadius.circular(borderRadius!),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: onTap,
      color: type == 'gradient' ? null : _getColor(type),
      child: Container(
        width: width,
        height: height,
        decoration: _getBoxDecoration(type),
        child: Center(
          child: Text(
            text,
            style: _getTextStyle(type),
          ),
        ),
      ),
    );
  }
}
