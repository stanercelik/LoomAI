import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';

class PurchaseService {
  /// RevenueCat SDK'yı başlatır
  Future<void> configureSDK() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
      final androidApiKey = dotenv.env['REVENUECAT_ANDROID_API_KEY'];
      if (androidApiKey != null) {
        configuration = PurchasesConfiguration(androidApiKey);
      }
    } else if (Platform.isIOS) {
      final iosApiKey = dotenv.env['REVENUECAT_IOS_API_KEY'];
      if (iosApiKey != null) {
        configuration = PurchasesConfiguration(iosApiKey);
      }
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  /// RevenueCat'ten mevcut offerings/paketleri getirir
  Future<List<Package>> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (e) {
      print('Error fetching offerings: $e');
      return [];
    }
  }

  /// Ürün kimliğine (örn: credits_10) göre yerelleştirilmiş isim döndürür
  String getLocalizedPackageName(String packageId) {
    Map<String, Map<String, String>> metadata = {
      "credits_5": {"tr": "5 Kredi", "en": "5 Credits"},
      "credits_10": {"tr": "10 Kredi", "en": "10 Credits"},
      "credits_20": {"tr": "20 Kredi", "en": "20 Credits"}
    };

    String locale = Get.locale?.languageCode ?? 'en';
    return metadata[packageId]?[locale] ?? packageId;
  }

  /// RevenueCatUI üzerinden hazır paywall gösterir
  Future<void> showPaywall() async {
    try {
      final paywallResult =
          await RevenueCatUI.presentPaywall(displayCloseButton: true);
      print('Paywall Result: $paywallResult');

      // Paywall kapandıktan veya satın alma tamamlandıktan sonra
      // en güncel müşteri bilgisini çekerek krediyi güncelle
      final customerInfo = await Purchases.getCustomerInfo();
      _handlePurchase(customerInfo, paywallShown: true);
    } catch (e) {
      throw Exception('Failed to show paywall: $e');
    }
  }

  /// (Opsiyonel) Manuel paket satın alma örneği
  Future<void> buyCredits(Package package) async {
    try {
      final CustomerInfo customerInfo =
          await Purchases.purchasePackage(package);

      _handlePurchase(customerInfo);
    } on PlatformException catch (e) {
      if (e.code == PurchasesErrorCode.purchaseNotAllowedError.toString() ||
          e.code == PurchasesErrorCode.purchaseInvalidError.toString()) {
        print('Purchase not allowed or invalid: $e');
      } else {
        print('buyCredits error: $e');
      }
      rethrow;
    } catch (e) {
      print('buyCredits unexpected error: $e');
      rethrow;
    }
  }

  /// Müşterinin satın aldığı ürün(ler)e bakarak StorageService üzerinden krediyi günceller
  void _handlePurchase(CustomerInfo customerInfo, {bool paywallShown = false}) {
    if (paywallShown) {
      print("Paywall shown, not updating credits automatically.");
      return;
    }

    // NonSubscriptionTransactions üzerinden ürün kimliklerini kontrol ediyoruz
    final nonSubTransactions = customerInfo.nonSubscriptionTransactions
        .map((t) => t.productIdentifier);

    // Hangi ürünü satın aldıysa o kadar kredi ekliyoruz
    for (var productId in nonSubTransactions) {
      if (productId == 'credits_5') {
        StorageService.to.updateCredits(StorageService.to.credits + 5);
      } else if (productId == 'credits_10') {
        StorageService.to.updateCredits(StorageService.to.credits + 10);
      } else if (productId == 'credits_20') {
        StorageService.to.updateCredits(StorageService.to.credits + 20);
      }
    }
  }
}
