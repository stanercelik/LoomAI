import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
      final current = offerings.current;
      
      return current?.availablePackages ?? [];
    } catch (e) {
      print('Error getting offerings: $e');
      return [];
    }
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      
      // Check if the user has the 'credits' entitlement
      final credits = purchaseResult.entitlements.active['credits'];
      return credits != null;
    } catch (e) {
      print('Error making purchase: $e');
      return false;
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      print('Error getting customer info: $e');
      rethrow;
    }
  }

  Future<bool> checkCreditsEntitlement() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active['credits']?.isActive ?? false;
    } catch (e) {
      print('Error checking credits entitlement: $e');
      return false;
    }
  }
}