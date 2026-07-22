import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/school_dashboard_statistics_model.dart';

class GetSchoolDashboardStatisticsRemoteDataSource {
  static Future<SchoolDashboardStatisticsModel> get() async {
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    final supabase = SupabaseDatabaseService();

    final response = await supabase.rpc(
      'get_school_overall_statistics_json',
      params: {'p_school_id': schoolId},
    );

    return SchoolDashboardStatisticsModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }
}
