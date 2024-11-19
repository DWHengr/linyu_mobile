import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final double vertical;
  final ValueChanged<String>? onChanged;
  final int? inputLimit;
  final bool readOnly;
  final int? maxLines; // 新增maxLines参数

  const CustomTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.hintText = '请输入内容',
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.suffixIcon,
    this.inputLimit,
    this.readOnly = false,
    this.maxLines = 1,
    this.vertical = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText ?? '',
            style: const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14.0),
          ),
        if (labelText != null) const SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            readOnly: readOnly,
            maxLines: maxLines,
            // 使用maxLines参数
            inputFormatters: inputLimit != null
                ? <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(inputLimit)
                  ]
                : null,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              suffix: suffix,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
              filled: true,
              fillColor: const Color(0xFFEDF2F9),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: vertical, horizontal: 8.0),
            ),
          ),
        ),
      ],
    );
  }
}
