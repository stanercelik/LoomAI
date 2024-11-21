import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _prefs;
  
  // Keys
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _creditsKey = 'credits';
  
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
  
  // First Launch Control
  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;
  
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_isFirstLaunchKey, value);
  }
  
  // Credits Management
  int get credits => _prefs.getInt(_creditsKey) ?? 3;  

  Future<void> setCredits(int value) async {
    await _prefs.setInt(_creditsKey, value);
  }
  
  Future<void> updateCredits(int value) async {
    await setCredits(value);
  }
}