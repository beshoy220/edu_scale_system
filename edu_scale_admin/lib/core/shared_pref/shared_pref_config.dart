import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefConfig {
  static Future<SharedPreferences> init() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
