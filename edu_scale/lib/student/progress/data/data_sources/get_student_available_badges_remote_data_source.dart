import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/progress/data/models/student_available_badge_model.dart';

class GetStudentAllAvailableBadgesRemoteDataSource {
  static Future<List<StudentAvailableBadgeModel>>
  getAllAvailableBadges() async {
    SupabaseDatabaseService supabaseDB = SupabaseDatabaseService();
    final response = await supabaseDB.from('badges').select().order('id');

    return (response as List)
        .map((json) => StudentAvailableBadgeModel.fromJson(json))
        .toList();
  }
}
