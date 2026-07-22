import 'package:edu_scale_admin/features/classes/data/models/class_statistics_model.dart';
import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';

class ClassStatisticsRemoteDataSource {
  Future<ClassStatisticsModel> getClassStatistics({
    required int classId,
  }) async {
    // 1. Get school_id from cache
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Get School Competition Stats
    final supabase = SupabaseDatabaseService();
    final response = await supabase.rpc(
      'get_class_statistics_json',
      params: {
        'school_id_param': schoolId,
        'class_id_param': classId,
        // 'start_date': startDate?.toIso8601String(),
        // 'end_date': endDate?.toIso8601String(),
      },
    );

    // RPC returns List<dynamic>, we take the first item which is the JSON string
    return ClassStatisticsModel.fromJson(Map<String, dynamic>.from(response));
  }
}
