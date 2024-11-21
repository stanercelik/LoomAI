import 'package:fal_client/fal_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:loom_ai_app/app/ui/pages/settings/settings_controller.dart';
import 'package:loom_ai_app/config/themes/theme.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiToken = dotenv.env['FALAI_API_TOKEN'];
  if (apiToken == null || apiToken.isEmpty) {
    throw Exception("API Token is not set in .env file");
  }

  // Initialize services
  await Get.putAsync(() => StorageService().init());
  Get.put(FalClient.withCredentials(apiToken));
  Get.put(SettingsController(), permanent: true);

  // Check if it's first launch
  final isFirstLaunch = StorageService.to.isFirstLaunch;
  final initialRoute = isFirstLaunch ? Routes.WELCOME : Routes.HOME;
  
  if (isFirstLaunch) {
    await StorageService.to.setFirstLaunch(false);
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();

    return Obx(() =>GetMaterialApp(
        title: 'LoomAI',
        debugShowCheckedModeBanner: false,
        translations: Messages(),
        fallbackLocale: const Locale('en', 'US'),
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: settingsController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        getPages: AppPages.pages,
        initialRoute: "/welcome",
      ),
    );
  }
}
