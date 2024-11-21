import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';

class WelcomeController extends GetxController {

  void navigateToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}
