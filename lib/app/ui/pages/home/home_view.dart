import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_action_button.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_form.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {

  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr),
        actions: [
          Obx(() => GestureDetector(
                onTap: () => Get.toNamed('/credits'),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Text(
                        '${'home.remainingCredits'.tr}: ${StorageService.to.credits}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: controller.navigateToSettings,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.generatedImageUrl.value.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.network(controller.generatedImageUrl.value)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => CarpetActionButton(
                      icon: Icons.save_alt,
                      onPressed: controller.saveImageToGallery,
                      label: 'home.saveToDevice'.tr,
                      isLoading: controller.isSavingLoading.value,
                    )),
                    const SizedBox(width: 32),
                    Obx(() => CarpetActionButton(
                      icon: Icons.share,
                      onPressed: controller.shareImage,
                      label: 'home.share'.tr,
                      isLoading: controller.isSharingLoading.value,
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    controller.generatedImageUrl.value = '';
                  },
                  child: Text('home.createNewCarpetButton'.tr, style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  )),
                ),
              ],
            ),
          );
        } else {
          return 
          
          
          Column(
            children: [
              const CarpetForm(),
                              /*ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: controller.addDebugCredits,
                  child: Text(
                    'Debug: +5 Kredi',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),*/
            ],
          );
        }
      }),
    );
  }
}
