import 'package:edu_scale_admin/core/shared_pref/shared_pref_config.dart';
import 'package:flutter/material.dart';

class CachedResources {
  // School Domain Resources
  static void setSchoolDomain(String domain) async {
    var initPrefs = await SharedPrefConfig.init();
    initPrefs.setString('school_domain', domain);
    debugPrint('Set School Domain Cache of: $domain');
  }

  static Future<String?> getSchoolDomain() async {
    var initPrefs = await SharedPrefConfig.init();
    String? res = initPrefs.getString('school_domain');
    debugPrint('Get School Domain Cache of: $res');
    return res;
  }

  // School Id Resources
  static void setSchoolId(String id) async {
    var initPrefs = await SharedPrefConfig.init();
    initPrefs.setString('school_id', id);
    debugPrint('Set School ID Cache of: $id');
  }

  static Future<String?> getSchoolId() async {
    var initPrefs = await SharedPrefConfig.init();
    String? res = initPrefs.getString('school_id');
    debugPrint('Get School ID Cache of: $res');
    return res;
  }

  static void setAppLanguageToEnglish(bool isEnglish) async {
    var initPrefs = await SharedPrefConfig.init();
    initPrefs.setBool('is_app_language_english', isEnglish);
    debugPrint(
      'Set App Language Cache To: ${isEnglish ? 'English' : 'Arabic'}',
    );
  }

  static Future<bool> isAppLanguageEnglish() async {
    var initPrefs = await SharedPrefConfig.init();
    bool? res = initPrefs.getBool('is_app_language_english');
    debugPrint('Get App Language Cache of: $res');

    if (res == null) {
      return true;
    } else {
      return res;
    }
  }

  // Clear All Prefs
  static void clearAllCache() async {
    var initPrefs = await SharedPrefConfig.init();
    initPrefs.clear();
    debugPrint('All Cache Cleared');
  }
}
