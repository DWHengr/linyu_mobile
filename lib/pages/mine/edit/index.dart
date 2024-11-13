import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_portrait/index.dart';
import 'package:linyu_mobile/components/custom_text_field/index.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

import 'logic.dart';

class EditMinePage extends CustomWidget<EditMineLogic> {
  EditMinePage({super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomPortrait(
                  onTap: () => controller.selectPortrait(context),
                  url: controller.currentUserInfo['portrait'] ?? '',
                  size: 100,
                  radius: 50),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.setSex('男'),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: controller.maleColorActive,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.male,
                              size: 20,
                              color: controller.maleTextColorActive,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '男生',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: controller.maleTextColorActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () => controller.setSex('女'),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: controller.femaleColorActive,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.female,
                              size: 20,
                              color: controller.femaleTextColorActive,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '女生',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: controller.femaleTextColorActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "昵称",
                controller: controller.nameController,
                inputLimit: 30,
                onChanged: controller.onNameTextChanged,
                readOnly: !controller.isEdit,
                suffix: Text('${controller.nameTextLength}/30'),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                labelText: "签名",
                controller: controller.signatureController,
                inputLimit: 30,
                onChanged: controller.onSignatureTextChanged,
                readOnly: !controller.isEdit,
                suffix: Text('${controller.signatureTextLength}/100'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "生日",
                controller: controller.birthdayController,
                readOnly: true,
                suffixIcon: IconButton(
                  onPressed: () => controller.selectDate(context),
                  icon: const Icon(Icons.calendar_today, size: 20),
                ),
              ),
              const Spacer(),
              !controller.isEdit
                  ? FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: controller.onPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          backgroundColor: const Color(0xFF4C9BFF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "编辑资料",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: controller.onPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          backgroundColor: const Color(0xFF4C9BFF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "保  存",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
