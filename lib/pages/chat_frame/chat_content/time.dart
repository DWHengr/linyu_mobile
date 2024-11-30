import 'package:flutter/material.dart';

class TimeContent extends StatelessWidget {
  late dynamic value;

  TimeContent({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3)),
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
