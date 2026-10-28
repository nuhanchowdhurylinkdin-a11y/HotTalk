import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _preferences;

  static const String _onboardingCompleteKey = 'onboardingComplete';
  static const String _setupCompleteKey = "setup";

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool get isOnboardingComplete =>
      _preferences?.getBool(_onboardingCompleteKey) ?? false;

  static Future<void> setOnboardingComplete(bool value) async {
    await _preferences?.setBool(_onboardingCompleteKey, value);
  }

  static bool get isSetupComplete =>
      _preferences?.getBool(_setupCompleteKey) ?? false;

  static Future<void> setSetupComplete(bool value) async {
    await _preferences?.setBool(_setupCompleteKey, value);
  }
}
