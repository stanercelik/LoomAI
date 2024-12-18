import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rate_my_app_controller.dart';

class RateMyAppDialog extends StatelessWidget {
  final RateMyAppController controller = Get.put(RateMyAppController());

  RateMyAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "Rate My App",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      ),
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Uygulamadan memnun kaldıysan puan vererek destek olabilirsin!",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              controller.currentEmoji,
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Slider(
              inactiveColor: Colors.grey.shade600,
              thumbColor: theme.colorScheme.secondary,
              value: controller.rating.value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: controller.rating.value.toString(),
              onChanged: (value) {
                controller.setRating(value.round());
              },
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () => controller.submitRating(),
          child: Text("Submit"),
        )
      ],
    );
  }
}
