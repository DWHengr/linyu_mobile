// custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final int? inputLimit;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.hintText = '请输入内容',
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.suffixIcon,
    this.inputLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 标签左对齐
      children: [
        Text(
          labelText,
          style:
              const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14.0), // 标签样式
        ),
        const SizedBox(height: 5.0), // 标签和输入框之间的间距
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F9), // 设置背景颜色为 #EDF2F9
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            inputFormatters: inputLimit != null
                ? <TextInputFormatter>[
                    //只输入数字
                    LengthLimitingTextInputFormatter(inputLimit) //限制长度
                  ]
                : null,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              suffix: suffix,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
              filled: true,
              // 填充背景
              fillColor: const Color(0xFFEDF2F9),
              isDense: true,
              // 填充背景颜色
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // 去除边框
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            ),
          ),
        ),
      ],
    );
  }
}
