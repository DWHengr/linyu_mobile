import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/components/custom_button/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';

class CustomDialog {
  static void showTipDialog(BuildContext context,
      {required String text,
        required VoidCallback onOk,
        VoidCallback? onCancel}) {
    GlobalThemeConfig theme = Get.find<GlobalThemeConfig>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '提示',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(text, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: '确定',
                        onTap: () {
                          onOk();
                          Navigator.of(context).pop();
                        },
                        width: 120,
                        height: 34,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: '取消',
                        onTap: () {
                          onCancel?.call();
                          Navigator.of(context).pop();
                        },
                        type: 'minor',
                        height: 34,
                        width: 120,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
