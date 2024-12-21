import 'dart:developer';

import 'package:get/get.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';

class CreditsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<String> packageNames = <String>[].obs;

  final PurchaseService purchaseService;

  CreditsController({required this.purchaseService});

  @override
  void onInit() {
    super.onInit();
    fetchPaywallContent();
  }

  Future<void> fetchPaywallContent() async {
    isLoading.value = true;
    try {
      // RevenueCat'ten paywall ve paket içeriğini çek
      final packages = await purchaseService.getOfferings();

      // Metadata kullanarak isimleri yerelleştir
      final localizedNames = packages.map((pkg) {
        return purchaseService
            .getLocalizedPackageName(pkg.storeProduct.identifier);
      }).toList();

      // Listeyi güncelle
      packageNames.assignAll(localizedNames);

      // Konsola yazdır
      for (var name in localizedNames) {
        log('Localized Package Name: $name');
      }
    } catch (e) {
      log('Error fetching paywall content: $e');
      Get.snackbar('Error', 'Failed to fetch paywall content: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showPaywall() async {
    try {
      final result = await purchaseService.showPaywall();
    } catch (e) {
      Get.snackbar('Error', 'Failed to show paywall: $e');
      log('Paywall Error: $e');
    }
  }
}
