import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/widgets/carpet_animation.dart';
import 'welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  final WelcomeController controller = Get.put(WelcomeController());

  WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Animation
          Opacity(
            opacity: 0.4,
            child: Center(
              child: Column(
                children: List.generate(5, (index) {
                  // Create 5 lines
                  return Expanded(
                    child: CarpetAnimation(
                      direction: index % 2 == 0
                          ? AxisDirection.right
                          : AxisDirection.left,
                    ),
                  );
                }),
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    theme.brightness == Brightness.dark
                        ? 'assets/images/logo_darkmode.png'
                        : 'assets/images/logo_lightmode.png',
                    width: 250,
                  ),
                  const SizedBox(height: 40),
                  // Title Text
                  Text(
                    'welcome.title'.tr,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Subtitle Text (Optional)
                  Text(
                    'welcome.subtitle'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.navigateToHome();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'welcome.startButton'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
