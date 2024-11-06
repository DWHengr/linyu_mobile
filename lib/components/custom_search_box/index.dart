import 'package:flutter/material.dart';

class CustomSearchBox extends StatelessWidget {
  final bool isCentered;
  final Color backgroundColor;
  final double borderRadius;
  final ValueChanged<String> onChanged;

  const CustomSearchBox({
    super.key,
    this.isCentered = false,
    this.backgroundColor = const Color(0xFFE3ECFF),
    this.borderRadius = 10.0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = const Color(0xFF4C9BFF);
    return Container(
      alignment: isCentered ? Alignment.center : Alignment.centerLeft,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment:
            isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(const IconData(0xe669, fontFamily: 'IconFont'),
              size: 20, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
              style: TextStyle(color: iconColor, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: '搜索',
                hintStyle: TextStyle(color: iconColor, fontSize: 16),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
