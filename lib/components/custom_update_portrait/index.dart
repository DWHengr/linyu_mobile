import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';

class CustomUpdatePortrait extends StatelessWidget {
  final String url;
  final double size;
  final double radius;
  final GestureTapCallback onTap;
  final bool isEdit;

  const CustomUpdatePortrait(
      {super.key,
      required this.url,
      this.size = 70,
      this.radius = 35,
      required this.onTap,
      this.isEdit = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPortrait(
          url: url,
          size: size,
          radius: radius,
        ),
        if (isEdit)
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(radius),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
