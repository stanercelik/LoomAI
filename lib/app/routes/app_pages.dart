import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/pages/carpet_result/carpet_result_view.dart';
import 'package:loom_ai_app/app/ui/pages/home/home_binding.dart';
import 'package:loom_ai_app/app/ui/pages/home/home_view.dart';
import 'package:loom_ai_app/app/ui/pages/settings/settings_binding.dart';
import 'package:loom_ai_app/app/ui/pages/settings/settings_view.dart';
import '../ui/pages/welcome/welcome_binding.dart';
import '../ui/pages/welcome/welcome_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Splash Page
    GetPage(
      name: Routes.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),

    // Home Page
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    // Market Page
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),

    // Result Page
    GetPage(
      name: Routes.RESULT,
      page: () => CarpetResultView(),
    ),
  ];
}
