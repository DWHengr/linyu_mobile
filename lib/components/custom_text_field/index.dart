import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final double vertical;
  final ValueChanged<String>? onChanged;
  final int? inputLimit;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final IconData? iconData;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.focusNode,
    this.hintText = '请输入内容',
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.suffixIcon,
    this.inputLimit,
    this.labelTextColor = const Color(0xFF1F1F1F),
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.vertical = 12.0,
    this.hintTextColor = Colors.grey,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText ?? '',
            style: TextStyle(color: labelTextColor, fontSize: 14.0),
          ),
        if (labelText != null) const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (iconData != null)
                Row(
                  children: [
                    Icon(iconData, size: 16.0, color: hintTextColor),
                    const SizedBox(width: 5.0),
                  ],
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  minLines: minLines,
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
                    hintStyle: TextStyle(color: hintTextColor, fontSize: 14.0),
                    filled: true,
                    fillColor: const Color(0xFFEDF2F9),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: vertical),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
