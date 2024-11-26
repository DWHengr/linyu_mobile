import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

class CustomLeastButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;

  const CustomLeastButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
