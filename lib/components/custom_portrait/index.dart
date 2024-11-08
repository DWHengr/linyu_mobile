import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomPortrait extends StatelessWidget {
  final double size;
  final String url;
  final double radius;

  const CustomPortrait(
      {super.key, this.size = 50, required this.url, this.radius = 25});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
    );
  }
}
