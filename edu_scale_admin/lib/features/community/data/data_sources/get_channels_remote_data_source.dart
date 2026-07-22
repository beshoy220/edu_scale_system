import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/channel_model.dart';

class GetChannelsRemoteDataSource {
  static Future<List<ChannelModel>> get() async {
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer.');
    }

    final supabase = SupabaseDatabaseService();

    final response = await supabase
        .from('channels')
        .select('''
        *,
        schools (
          id,
          name
        ),
        grades (
          id,
          name
        ),
        classes (
          id,
          name,
          nickname
        )
      ''')
        .eq('school_id', schoolId);

    return (response as List).map((e) => ChannelModel.fromJson(e)).toList();
  }
}
