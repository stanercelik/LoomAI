import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/custom_textfield.dart';
import '../pages/home/home_controller.dart';

class CarpetForm extends GetView<HomeController> {
  const CarpetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: controller.promptController,
              label: 'home.promptLabel'.tr,
              hint: 'home.promptHint'.tr,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.renkPaletiController,
              label: 'home.colorPaletteLabel'.tr,
              hint: 'home.colorPaletteHint'.tr,
            ),
            CustomTextField(
              controller: controller.kenarMotifleriController,
              label: 'home.borderPatternLabel'.tr,
              hint: 'home.borderPatternHint'.tr,
            ),
            CustomTextField(
              controller: controller.merkezMotifiController,
              label: 'home.centerPatternLabel'.tr,
              hint: 'home.centerPatternHint'.tr,
            ),
            const SizedBox(height: 20),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedSize.value,
                  items: controller.sizeOptions
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedSize.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'home.sizeLabel'.tr,
                    border: const OutlineInputBorder(),
                  ),
                )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.createCarpet,
                child: Text('home.createCarpetButton'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
