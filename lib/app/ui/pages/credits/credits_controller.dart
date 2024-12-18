import 'package:get/get.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class CreditsController extends GetxController {
  final RxList<Package> packages = <Package>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt remainingCredits = 0.obs;
  final RxString selectedPackage = ''.obs;

  final PurchaseService purchaseService;

  CreditsController({required this.purchaseService});

  @override
  void onInit() {
    super.onInit();
    _loadCredits();
    fetchPackages();
  }

  void _loadCredits() {
    remainingCredits.value = StorageService.to.credits;
  }

  void selectPackage(String productId) {
    selectedPackage.value = productId;
  }

  Future<void> _updateCredits(int creditsToAdd) async {
    final newCredits = StorageService.to.credits + creditsToAdd;
    await StorageService.to.setCredits(newCredits);
    remainingCredits.value = newCredits;
  }

  Future<void> fetchPackages() async {
    isLoading.value = true;
    try {
      final fetchedPackages = await purchaseService.getOfferings();
      packages.assignAll(fetchedPackages);
    } catch (e) {
      print('Paketler alınamadı: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseSelectedPackage() async {
    if (selectedPackage.value.isEmpty) {
      Get.snackbar(
        'credits.purchaseError'.tr,
        'credits.selectPackageFirst'.tr,
      );
      return;
    }

    await purchaseProduct(selectedPackage.value);
  }

  Future<void> purchaseProduct(String productId) async {
    isLoading.value = true;
    try {
      // Paketleri filtrele ve eşleşen bir paket olup olmadığını kontrol et
      final matchedPackages = packages.where(
        (pkg) => pkg.storeProduct.identifier == productId,
      );

      if (matchedPackages.isEmpty) {
        Get.snackbar(
          'credits.purchaseError'.tr,
          'Ürün bulunamadı. Play Console yapılandırması gerekiyor.',
        );
        print('Ürün ID: $productId bulunamadı');
        return;
      }

      final selectedPkg = matchedPackages.first;

      // Package üzerinden satın alma
      final success = await purchaseService.purchasePackage(selectedPkg);

      if (success) {
        int creditsToAdd = 0;
        switch (productId) {
          case 'credits_5':
            creditsToAdd = 5;
            break;
          case 'credits_10':
            creditsToAdd = 10;
            break;
          case 'credits_20':
            creditsToAdd = 20;
            break;
        }

        await _updateCredits(creditsToAdd);
        Get.snackbar(
          'credits.purchaseSuccess'.tr,
          '$creditsToAdd kredi satın alındı!',
        );
        selectedPackage.value = '';
      } else {
        Get.snackbar(
          'credits.purchaseError'.tr,
          'Satın alma işlemi başarısız veya iptal edildi.',
        );
      }
    } catch (e) {
      print('Satın alma hatası: $e');
      Get.snackbar(
        'credits.purchaseError'.tr,
        'Satın alma işlemi sırasında bir hata oluştu: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
