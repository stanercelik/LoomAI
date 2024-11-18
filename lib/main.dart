import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:loom_ai_app/config/themes/theme.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LoomAI',
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: const Locale('tr', 'TR'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Cihazın temasını kullan
      getPages: AppPages.pages,
      initialRoute: Routes.SPLASH,
    );
  }
}
