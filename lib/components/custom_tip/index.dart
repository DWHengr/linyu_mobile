import 'package:flutter/material.dart';

class CustomTip extends StatelessWidget {
  final int count;
  final double right;
  final double top;

  const CustomTip(this.count, {super.key, this.right = -10, this.top = -5});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: Container(
        height: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
        ),
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
