import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/parent/progress/data/models/parent_available_badge_model.dart';

class GetParentAllAvailableBadgesRemoteDataSource {
  static Future<List<ParentAvailableBadgeModel>> getAllAvailableBadges() async {
    SupabaseDatabaseService supabaseDB = SupabaseDatabaseService();
    final response = await supabaseDB.from('badges').select().order('id');

    return (response as List)
        .map((json) => ParentAvailableBadgeModel.fromJson(json))
        .toList();
  }
}
