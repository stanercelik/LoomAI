import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/custom_textfield.dart';
import '../pages/home/home_controller.dart';

class CarpetForm extends GetView<HomeController> {
  const CarpetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CustomTextField(
                maxLines: 5,
                controller: controller.promptController,
                label: 'home.promptLabel'.tr,
                hint: 'home.promptHint'.tr,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.renkPaletiController,
              label: 'home.colorPaletteLabel'.tr,
              hint: 'home.colorPaletteHint'.tr,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.kenarMotifleriController,
              label: 'home.borderPatternLabel'.tr,
              hint: 'home.borderPatternHint'.tr,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.merkezMotifiController,
              label: 'home.centerPatternLabel'.tr,
              hint: 'home.centerPatternHint'.tr,
            ),
            const SizedBox(height: 24),
            Theme(
              data: theme.copyWith(
                inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                ),
              ),
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedSize.value,
                    items: controller.sizeOptions
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(
                                size,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedSize.value = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'home.sizeLabel'.tr,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    dropdownColor: theme.colorScheme.surface,
                    icon: Icon(Icons.arrow_drop_down_circle_outlined, color: theme.colorScheme.primary),
                  )),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: controller.createCarpet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'home.createCarpetButton'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
