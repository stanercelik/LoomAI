import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateMyAppController extends GetxController {
  RxInt rating = 5.obs;
  RxBool hasRated = false.obs;

  Future<void> checkIfUserRated() async {
    final prefs = await SharedPreferences.getInstance();
    hasRated.value = prefs.getBool('hasRated') ?? false;
  }

  Future<void> setUserRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasRated', true);
  }

  String get currentEmoji {
    switch (rating.value) {
      case 1:
        return "😭";
      case 2:
        return "😢";
      case 3:
        return "😐";
      case 4:
        return "🙂";
      case 5:
        return "😁";
      default:
        return "😐";
    }
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> submitRating() async {
    if (!hasRated.value) {
      debugPrint("User Rating: ${rating.value}");
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        if (Platform.isIOS) {
          await inAppReview.openStoreListing(
            appStoreId: 'com.tanercelik.loom_ai_app',
          );
        } else if (Platform.isAndroid) {
          await inAppReview.openStoreListing(
            appStoreId: 'com.tanercelik.loom_ai_app',
          );
        }
      }

      // Kullanıcının değerlendirdiğini işaretle
      await setUserRated();
      Get.back();
    } else {
      Get.snackbar(
        "Already Rated",
        "You have already rated this app. Thank you!",
      );
    }
  }
}
