import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/quiz_statistics_model.dart';

class GetQuizStatisticsRemoteDataSource {
  static Future<QuizStatisticsModel> get() async {
    // 1. Get school_id from cache
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Call the updated RPC function
    final supabase = SupabaseDatabaseService();
    final response = await supabase.rpc(
      'get_quiz_statistics_json',
      params: {
        'p_school_id': schoolId,
        // Optional parameters
        // 'p_start_date': null,
        // 'p_end_date': null,
      },
    );

    // RPC returns a single JSON object
    final data = response as Map<String, dynamic>;

    return QuizStatisticsModel.fromJson(data);
  }
}
