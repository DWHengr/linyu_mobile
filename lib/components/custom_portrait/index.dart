import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomPortrait extends StatelessWidget {
  final double size;
  final String url;
  final double radius;
  final VoidCallback? onTap;
  final bool? isGreyColor;

  const CustomPortrait({
    super.key,
    this.size = 50,
    required this.url,
    this.radius = 25,
    this.onTap,
    this.isGreyColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: size,
                height: size,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffffffff),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: size,
                height: size,
                color: Colors.grey[300],
                child: Image.asset('assets/images/default-portrait.jpeg'),
              ),
            ),
          ),
          Opacity(
            opacity: !isGreyColor! ?  0:  0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                width: size,
                height: size,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
