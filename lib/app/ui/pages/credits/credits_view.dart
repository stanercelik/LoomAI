import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_animation.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'credits_controller.dart';

class CreditsView extends GetView<CreditsController> {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => Text(
                  '${'credits.currentCredits'.tr}: ${controller.remainingCredits.value}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                )),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: const Positioned.fill(
                    child: CarpetAnimation(
                      direction: AxisDirection.left,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 36.0, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'credits.header'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'credits.subHeader'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.packages.length,
                itemBuilder: (context, index) {
                  final package = controller.packages[index];
                  final isPopular =
                      package.storeProduct.identifier.contains('10');
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: _buildCreditPackage(
                      context,
                      package: package,
                      isPopular: isPopular,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: controller.selectedPackage.value != null
                          ? () => controller.purchaseSelectedPackage()
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'credits.purchaseButton'.tr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  )),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCreditPackage(
    BuildContext context, {
    required Package package,
    required bool isPopular,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPackage.value == package;
      return Card(
        elevation: isSelected || isPopular ? 10 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => controller.selectPackage(package),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.4),
                width: isSelected ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'credits.mostPopular'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  controller.purchaseService.getLocalizedPackageName(
                    package.storeProduct.identifier,
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  package.storeProduct.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      package.storeProduct.priceString,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (isPopular)
                      Text(
                        'credits.saveLabel'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
