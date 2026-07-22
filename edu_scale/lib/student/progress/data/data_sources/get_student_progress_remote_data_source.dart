import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/progress/data/models/student_progress_model.dart';

class GetStudentProgressRemoteDataSource {
  Future<StudentProgressModel?> getProgress() async {
    final currentUser = await AccountManager.currentAccount();
    final userId = currentUser!.id;

    final supabaseDB = SupabaseDatabaseService();

    final progress = await supabaseDB
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (progress == null) {
      return null;
    }

    final badges = await supabaseDB
        .from('user_badges')
        .select('''
          earned_at,
          badges(
            id,
            name,
            description,
            icon_url,
            category,
            requirement,
            requirement_value
          )
        ''')
        .eq('user_id', userId);

    progress['user_badges'] = badges;

    return StudentProgressModel.fromJson(progress);
  }
}
