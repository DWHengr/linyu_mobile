import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

class CustomLabelValueButton extends StatelessWidget {
  final String label;
  final String? value;
  final double? width;
  final VoidCallback onTap;
  final int? maxLines;
  final Widget? child;
  final String hint;

  const CustomLabelValueButton({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.child,
    this.maxLines = 5,
    this.hint = '',
    this.width = 60,
  });

  Widget _getContent() {
    if (null == child && (value == null || value!.trim().isEmpty)) {
      return Text(
        hint,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black38,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    return child ??
        Text(
          value!,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: _getContent(),
            ),
            Icon(
              const IconData(0xe61f, fontFamily: 'IconFont'),
              size: 16,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
