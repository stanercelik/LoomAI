import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/pages/home/home_controller.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_action_button.dart';
import 'package:loom_ai_app/app/ui/widgets/rate_my_app/rate_my_app_dialog.dart';

class CarpetResultView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  CarpetResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('result.title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.generatedImageUrl.value.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, left: 16.0, right: 16.0),
                    child: Container(
                        alignment: Alignment.center,
                        child:
                            Image.network(controller.generatedImageUrl.value)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => CarpetActionButton(
                            icon: Icons.save_alt,
                            onPressed: controller.saveImageToGallery,
                            label: 'result.saveToDevice'.tr,
                            isLoading: controller.isSavingLoading.value,
                          )),
                      const SizedBox(width: 32),
                      Obx(() => CarpetActionButton(
                            icon: Icons.share,
                            onPressed: controller.shareImage,
                            label: 'result.share'.tr,
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
                      controller.navigateToHome();
                      Get.dialog(RateMyAppDialog());
                      controller.generatedImageUrl.value = '';
                    },
                    child: Text('result.createNewCarpetButton'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        )),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("No Image Generated"),
            );
          }
        }),
      ),
    );
  }
}
