import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linyu_mobile/components/custom_text_button/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/pages/contacts/friend_information/set_remark/logic.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class SetRemarkPage extends CustomWidget<SetRemarkLogic> {
  SetRemarkPage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('好友备注'),
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            CustomTextButton('完成',
                onTap: controller.onSetRemark,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                fontSize: 14),
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            CustomTextField(
              labelText: "备注",
              controller: controller.remarkController,
              inputLimit: 10,
              hintText: "请输入用户备注~",
              onChanged: controller.onRemarkChanged,
              suffix: Text('${controller.remarkLength}/10'),
            ),
          ],
        ),
      ),
    );
  }
}
