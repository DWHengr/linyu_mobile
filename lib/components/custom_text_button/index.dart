import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;
  final double fontSize;

  const CustomTextButton(this.value,
      {super.key, required this.onTap, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF4C9BFF),
        ),
      ),
    );
  }
}
