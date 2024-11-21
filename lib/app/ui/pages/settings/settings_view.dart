import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized
    final SettingsController controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('settings.title'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Theme Toggle
            Obx(() => SwitchListTile(
                  title: Text('settings.darkMode'.tr),
                  value: controller.isDarkMode.value,
                  onChanged: (value) => controller.toggleTheme(),
                )),

            const SizedBox(height: 20),

            // Language Selection
            Obx(() => ListTile(
                  title: Text('settings.language'.tr),
                  trailing: DropdownButton<String>(
                    value: controller.currentLanguage.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'tr',
                        child: Text('Türkçe'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeLanguage(value);
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}