import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/competition_statistics_model.dart';

class GetCompetitionStatisticsRemoteDataSource {
  static get() async {
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
      'get_competition_statistics_json',
      params: {'p_school_id': schoolId},
    );

    // RPC returns List<dynamic>
    final data = response;

    return CompetitionStatisticsModel.fromJson(data);
  }
}
