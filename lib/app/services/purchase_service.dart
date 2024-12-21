import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class PurchaseService {
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

  Future<List<Package>> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (e) {
      print('Error fetching offerings: $e');
      return [];
    }
  }

  String getLocalizedPackageName(String packageId) {
    Map<String, Map<String, String>> metadata = {
      "credits_5": {"tr": "5 Kredi", "en": "5 Credits"},
      "credits_10": {"tr": "10 Kredi", "en": "10 Credits"},
      "credits_20": {"tr": "20 Kredi", "en": "20 Credits"}
    };

    String locale = Get.locale?.languageCode ?? 'en';
    return metadata[packageId]?[locale] ?? packageId;
  }

  Future<void> showPaywall() async {
    try {
      final paywallResult =
          await RevenueCatUI.presentPaywall(displayCloseButton: true);
      print('Paywall Result: $paywallResult');
    } catch (e) {
      throw Exception('Failed to show paywall: $e');
    }
  }
}
