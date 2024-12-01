import 'package:flutter/material.dart';

class RetractionMessage extends StatelessWidget {
  final bool isRight;

  const RetractionMessage({
    super.key,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 20,
      constraints: const BoxConstraints(minHeight: 20),
      child: Text(
        isRight ? "你撤回了一条消息" : "对方撤回了一条消息",
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
    );
  }
}
