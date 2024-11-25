import 'package:flutter/material.dart';

class CustomGradientLine extends StatelessWidget {
  final double width;
  final double height;
  final Gradient gradient;

  const CustomGradientLine({
    super.key,
    required this.width,
    required this.height,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _GradientLinePainter(gradient: gradient),
    );
  }
}

class _GradientLinePainter extends CustomPainter {
  final Gradient gradient;

  _GradientLinePainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
