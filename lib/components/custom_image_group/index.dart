import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

final _userApi = UserApi();

class CustomImageGroup extends StatelessWidget {
  final List<dynamic> imagesList;
  final String userId;
  List<String> imageUrls = [];

  CustomImageGroup({
    super.key,
    required this.imagesList,
    required this.userId,
  }) : imageUrls = List.filled(imagesList.length, '');

  void _handlerOpenImageViewer(index) {
    Get.toNamed('/image_viewer',
        arguments: {'imageUrls': imageUrls, 'currentIndex': index});
  }

  Future<String> onGetImg(String fileName, String userId, int index) async {
    dynamic res = await _userApi.getImg(fileName, userId);
    if (res['code'] == 0) {
      imageUrls[index] = res['data'];
      return res['data'];
    }
    return '';
  }

  Widget _buildTalkImage(String imageStr, String userId, int index) {
    return CustomMaterialButton(
      onTap: () => _handlerOpenImageViewer(index),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder<String>(
          future: onGetImg(imageStr, userId, index),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CachedNetworkImage(
                imageUrl: snapshot.data ?? '',
                fit: BoxFit.cover,
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
              );
            } else {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffffffff),
                    strokeWidth: 2,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<dynamic> imageUrls, String userId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return _buildTalkImage(imageUrls[index], userId, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageGrid(imagesList, userId);
  }
}
