import 'package:fal_client/fal_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
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

  Get.put(FalClient.withCredentials(apiToken));

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
