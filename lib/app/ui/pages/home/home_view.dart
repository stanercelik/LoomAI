import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            onPressed: controller.navigateToMarket,
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
                Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: Image.network(controller.generatedImageUrl.value)),
                const SizedBox(height: 16),
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
                  onPressed: () {
                    controller.generatedImageUrl.value = '';
                  },
                  child: Text('home.createNewCarpetButton'.tr),
                ),
              ],
            ),
          );
        } else {
          return const CarpetForm();
        }
      }),
    );
  }
}
