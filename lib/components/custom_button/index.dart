import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

class CustomButton extends StatelessWidget {
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
        return const Color(0xFF4C9AFF);
      case 'minor':
        return const Color(0xFFEDF2F9);
      default:
        return const Color(0xFF4C9AFF);
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

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: onTap,
      color: _getColor(type),
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
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
