import 'package:edu_scale_admin/core/shared_pref/cached_resources.dart';

class Cache {
  static void setSchoolDomain(String domain) {
    CachedResources.setSchoolDomain(domain);
  }

  static Future<String?> getSchoolDomain() {
    return CachedResources.getSchoolDomain();
  }

  static void setSchoolId(String id) {
    CachedResources.setSchoolId(id);
  }

  static Future<String?> getSchoolId() {
    return CachedResources.getSchoolId();
  }

  static void clearAll() {
    CachedResources.clearAllCache();
  }
}
