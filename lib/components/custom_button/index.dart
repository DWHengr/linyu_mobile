import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomButton extends StatelessThemeWidget {
  final String text;
  final VoidCallback onTap;
  final String type;
  final double? width;

  const CustomButton(
      {super.key,
      required this.text,
      this.width = 200,
      this.type = 'primary',
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
        return const TextStyle(color: Colors.white, fontSize: 16);
      case 'minor':
        return const TextStyle(color: Color(0xFF1F1F1F), fontSize: 16);
      default:
        return const TextStyle(color: Colors.white, fontSize: 16);
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
          borderRadius: BorderRadius.circular(10),
        );
      default:
        return BoxDecoration(
          color: _getColor(type),
          borderRadius: BorderRadius.circular(10),
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
        height: 40,
        decoration: _getBoxDecoration(type),
        padding: const EdgeInsets.all(10),
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
