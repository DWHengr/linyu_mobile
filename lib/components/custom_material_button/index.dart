import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final Color? color;

  const CustomMaterialButton(
      {required this.child,
        required this.onTap,
        this.color,
        this.borderRadius = 10,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color ?? Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
