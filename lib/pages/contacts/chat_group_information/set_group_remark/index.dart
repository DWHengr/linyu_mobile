import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linyu_mobile/components/app_bar_title/index.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/contacts/chat_group_information/set_group_remark/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class SetGroupRemarkPage extends CustomWidget<SetGroupRemarkLogic> {
  SetGroupRemarkPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle('群备注'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            CustomTextButton('完成',
                onTap: controller.onSetName,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                fontSize: 14),
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(
              () => CustomTextField(
                labelText: "群备注",
                controller: controller.remarkController,
                onChanged: (value) {
                  controller.remarkLength.value = value.length;
                },
                inputLimit: 10,
                hintText: "请输入群备注~",
                suffix: Text('${controller.remarkLength.value}/10'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
