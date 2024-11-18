import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              theme.brightness == Brightness.dark
                  ? 'assets/images/logo_darkmode.png'
                  : 'assets/images/logo_lightmode.png',
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'splash.title'.tr,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.HOME); // Market ekranına geçiş
              },
              child: Text('splash.startButton'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
