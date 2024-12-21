import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_form.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final PurchaseService service = Get.put(PurchaseService());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr),
        actions: [
          Obx(() => GestureDetector(
                onTap: () => {service.showPaywall()},
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 24,
            ),
            child: CarpetForm(),
          ),
        ),
      ),
    );
  }
}
