import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/attendance_statistics_model.dart';

class GetAttendanceStatisticsRemoteDataSource {
  static Future<AttendanceStatisticsModel> get() async {
    // 1. Get school_id from cache
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Call the RPC function (the one we created earlier)
    final supabase = SupabaseDatabaseService();
    final response = await supabase.rpc(
      'get_attendance_statistics_json',
      params: {
        'school_id_param': schoolId,
        // 'start_date': startDate?.toIso8601String().split('T').first, // YYYY-MM-DD
        // 'end_date': endDate?.toIso8601String().split('T').first,
      },
    );

    // RPC returns a JSON object
    final data = response as Map<String, dynamic>;

    return AttendanceStatisticsModel.fromJson(data);
  }
}
