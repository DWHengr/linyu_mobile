import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomImage extends StatelessWidget {
  final String url;

  const CustomImage({super.key, required this.url});

  void onOpenImage() {
    Get.toNamed('/image_viewer_update', arguments: {
      'imageUrl': url,
      'isUpdate': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenImage,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CachedNetworkImage(
          width: double.infinity,
          imageUrl: url ?? '',
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xffffffff),
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/empty-bg.png'),
        ),
      ),
    );
  }
}
