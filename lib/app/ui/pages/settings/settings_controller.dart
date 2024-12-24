import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final RxString currentLanguage = 'en'.obs;

  // Keys for SharedPreferences
  static const String _darkModeKey = 'darkMode';
  static const String _languageKey = 'language';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load dark mode preference
    if (prefs.containsKey(_darkModeKey)) {
      isDarkMode.value = prefs.getBool(_darkModeKey)!;
    } else {
      // If not set, initialize based on system theme
      final Brightness systemBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      isDarkMode.value = systemBrightness == Brightness.dark;
    }

    // Apply the theme
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // Load language preference
    if (prefs.containsKey(_languageKey)) {
      currentLanguage.value = prefs.getString(_languageKey)!;
      final country = currentLanguage.value == 'tr' ? 'TR' : 'US';
      Get.updateLocale(Locale(currentLanguage.value, country));
    } else {
      // Initialize language based on system locale
      await _initializeLanguage();
    }
  }

  Future<void> _initializeLanguage() async {
    try {
      final locale = await _getPlatformLocale();
      final languageCode = locale.languageCode;
      if (languageCode == 'tr') {
        currentLanguage.value = 'tr';
        Get.updateLocale(const Locale('tr', 'TR'));
      } else {
        currentLanguage.value = 'en';
        Get.updateLocale(const Locale('en', 'US'));
      }
    } catch (e) {
      // Fallback to English if there's an error
      currentLanguage.value = 'en';
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  Future<Locale> _getPlatformLocale() async {
    final String? systemLocale =
        await SystemChannels.platform.invokeMethod<String>('getSystemLocale');
    final localeString = systemLocale ?? 'en_US';
    final parts = localeString.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode.value);
  }

  void changeLanguage(String languageCode) async {
    currentLanguage.value = languageCode;
    final country = languageCode == 'tr' ? 'TR' : 'US';
    Get.updateLocale(Locale(languageCode, country));

    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
