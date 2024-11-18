import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/custom_textfield.dart';
import 'home_controller.dart';
import '../../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr),
        actions: [
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${'home.remainingCredits'.tr}: ${controller.remainingCredits.value}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              Get.toNamed(Routes.MARKET);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Prompt TextField
              CustomTextField(
                controller: controller.promptController,
                label: 'home.promptLabel'.tr,
                hint: 'home.promptHint'.tr,
              ),

              const SizedBox(height: 20),

              // Other TextFields
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
                controller: controller.pusatController,
                label: 'home.tasselLabel'.tr,
                hint: 'home.tasselHint'.tr,
              ),
              CustomTextField(
                controller: controller.merkezMotifiController,
                label: 'home.centerPatternLabel'.tr,
                hint: 'home.centerPatternHint'.tr,
              ),
              const SizedBox(height: 20),
              // Halının Boyutu Dropdown
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

              // Create Rug Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.createCarpet,
                  child: Text('home.createButton'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
