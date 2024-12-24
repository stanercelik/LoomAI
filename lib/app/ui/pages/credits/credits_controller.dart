import 'package:get/get.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class CreditsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Package> packages = <Package>[].obs;
  final Rxn<Package> selectedPackage = Rxn<Package>();
  final RxInt remainingCredits = 0.obs;

  final PurchaseService purchaseService;

  CreditsController({required this.purchaseService});

  @override
  void onInit() {
    super.onInit();
    remainingCredits.value = StorageService.to.credits;
    fetchPaywallContent();
  }

  Future<void> fetchPaywallContent() async {
    isLoading.value = true;
    try {
      final offerings = await purchaseService.getOfferings();
      packages.value = offerings;
    } catch (e) {
      print('Error fetching packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPackage(Package package) {
    selectedPackage.value = package;
  }

  Future<void> purchaseSelectedPackage() async {
    if (selectedPackage.value == null) return;

    try {
      await purchaseService.buyCredits(selectedPackage.value!);
      remainingCredits.value = StorageService.to.credits;
      Get.back();
    } catch (e) {
      print('Error purchasing package: $e');
    }
  }
}
