import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _prefs;

  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _creditsKey = 'credits';

  final RxInt _credits = 3.obs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _credits.value = _prefs.getInt(_creditsKey) ?? 3;
    return this;
  }

  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_isFirstLaunchKey, value);
  }

  int get credits => _credits.value;

  Future<void> setCredits(int value) async {
    await _prefs.setInt(_creditsKey, value);
    _credits.value = value;
  }

  Future<void> updateCredits(int value) async {
    await setCredits(value);
  }
}
