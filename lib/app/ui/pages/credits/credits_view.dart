import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_animation.dart';
import 'credits_controller.dart';

class CreditsView extends GetView<CreditsController> {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('credits.title'.tr),
        centerTitle: true,
        actions: [ Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => Text(
              '${'credits.currentCredits'.tr}: ${controller.remainingCredits.value}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            )),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Carpet Animation at the top
                  const SizedBox(
                    height: 200,
                    child: CarpetAnimation(direction: AxisDirection.right,),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Credit Packages
                        _buildCreditPackage(
                          context,
                          title: 'credits.package5.title'.tr,
                          description: 'credits.package5.description'.tr,
                          price: 'credits.package5.price'.tr,
                          productId: 'credits_5',
                          isPopular: false,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildCreditPackage(
                          context,
                          title: 'credits.package10.title'.tr,
                          description: 'credits.package10.description'.tr,
                          price: 'credits.package10.price'.tr,
                          productId: 'credits_10',
                          isPopular: true,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildCreditPackage(
                          context,
                          title: 'credits.package20.title'.tr,
                          description: 'credits.package20.description'.tr,
                          price: 'credits.package20.price'.tr,
                          productId: 'credits_20',
                          isPopular: false,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Purchase Button
                        Obx(() => ElevatedButton(
                          onPressed: controller.selectedPackage.value.isNotEmpty
                              ? controller.purchaseSelectedPackage
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCreditPackage(
    BuildContext context, {
    required String title,
    required String description,
    required String price,
    required String productId,
    required bool isPopular,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPackage.value == productId;
      
      return Card(
        elevation: isSelected || isPopular ? 8 : 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isPopular
                      ? Theme.of(context).primaryColor.withOpacity(0.5)
                      : Colors.transparent,
              width: isSelected ? 3 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => controller.selectPackage(productId),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPopular) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Most Popular',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}