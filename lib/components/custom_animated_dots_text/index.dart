import 'package:flutter/material.dart';

class CustomAnimatedDotsText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  const CustomAnimatedDotsText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 1200),
    this.textStyle,
    this.decoration,
    this.padding,
  });

  @override
  State<CustomAnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<CustomAnimatedDotsText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(4),
      decoration: widget.decoration ??
          BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          int dots = (_controller.value * 3).floor() + 1;
          return Text(
            '${widget.text}${'.' * (dots % 4)}',
            style: widget.textStyle ??
                const TextStyle(fontSize: 14, color: Colors.white),
          );
        },
      ),
    );
  }
}
