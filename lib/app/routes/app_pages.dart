import 'package:get/get.dart';
import 'package:loom_ai_app/app/ui/pages/home/home_binding.dart';
import 'package:loom_ai_app/app/ui/pages/home/home_view.dart';
import '../ui/pages/splash/splash_binding.dart';
import '../ui/pages/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Splash Page
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    // Home Page
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    // Market Page
    GetPage(
      name: Routes.MARKET,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
