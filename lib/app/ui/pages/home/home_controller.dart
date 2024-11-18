import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';

class HomeController extends GetxController {
  // Kredi sayısı
  var remainingCredits = 3.obs;

  // TextField Controller'ları
  final promptController = TextEditingController();
  final renkPaletiController = TextEditingController();
  final kenarMotifleriController = TextEditingController();
  final pusatController = TextEditingController(); // Püskül
  final merkezMotifiController = TextEditingController();

  // Halının boyutu için seçenekler
  final List<String> sizeOptions = ['16:9', '1:1', '4:3'];
  var selectedSize = '16:9'.obs;

  @override
  void onClose() {
    promptController.dispose();
    renkPaletiController.dispose();
    kenarMotifleriController.dispose();
    pusatController.dispose();
    merkezMotifiController.dispose();
    super.onClose();
  }

  // Create Carpet Method
  void createCarpet() {
    if (remainingCredits.value > 0) {
      // Decrease Credit
      remainingCredits.value--;
      // Start the creating process
      // ...
    } else {
      // Don't enough credit, navigate to market page
      Get.snackbar('home.error.title.notEnoughCredit'.tr,
          'home.error.message.notEnoughCredit'.tr);
      Get.toNamed(Routes.MARKET);
    }
  }
}
