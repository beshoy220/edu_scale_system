import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/shared_pref/cached_resources.dart';

class GetUserStatistics {
  Future<Map<String, Map<String, int>>> get() async {
    // 1. Get school_id from cache
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    final supabase = SupabaseDatabaseService();

    final roles = ['admin', 'teacher', 'student', 'parent'];

    final Map<String, Map<String, int>> schoolStatistics = {};

    for (final role in roles) {
      // Total count for role
      final totalResponse = await supabase
          .from('users')
          .count(CountOption.exact)
          .eq('role', role)
          .eq('school_id', schoolId);

      // Active count for role
      final activeResponse = await supabase
          .from('users')
          .count(CountOption.exact)
          .eq('role', role)
          .eq('status', 'active')
          .eq('school_id', schoolId);

      schoolStatistics[role] = {
        'total': totalResponse,
        'active': activeResponse,
      };
    }

    return schoolStatistics;
  }
}
