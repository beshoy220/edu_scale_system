import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/parent/progress/data/models/parent_progress_model.dart';

class GetParentProgressRemoteDataSource {
  Future<ParentProgressModel?> getProgress() async {
    final currentUser = await AccountManager.currentAccount();
    final userId = currentUser!.ids.studentId!;

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

    return ParentProgressModel.fromJson(progress);
  }
}
