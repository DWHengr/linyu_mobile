import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/api/msg_api.dart';
import 'package:linyu_mobile/components/custom_image/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class ImageMessage extends StatelessThemeWidget {
  final _msgApi = MsgApi();
  final dynamic value;
  final bool isRight;

  ImageMessage({
    super.key,
    required this.value,
    required this.isRight,
  });

  Future<String> onGetImg() async {
    dynamic res = await _msgApi.getMedia(value['id']);
    if (res['code'] == 0) {
      return res['data'];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(Get.context!).size.width * 0.4,
      width: MediaQuery.of(Get.context!).size.width * 0.4,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: FutureBuilder<String>(
        future: onGetImg(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomImage(url: snapshot.data ?? '');
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
    );
  }
}
