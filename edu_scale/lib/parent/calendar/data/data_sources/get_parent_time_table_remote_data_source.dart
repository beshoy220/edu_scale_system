import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/parent/calendar/data/models/parent_time_table_session_model.dart';

class GetParentTimeTableRemoteDataSource {
  Future<List<ParentTimetableSessionModel>> getTimeTableSessions({
    required int dayOfWeek,
  }) async {
    // 1] Get current parent's child information
    final currentUser = await AccountManager.currentAccount();

    // 2] Fetch timetable sessions
    final supabase = SupabaseDatabaseService();
    final res = await supabase
        .from('timetable')
        .select('''
          id,
          day_of_week,
          start_at,
          end_at,
          room,
          created_at,
          subject:subjects(
            name
          ),
          teacher:users(
            name
          )
        ''')
        .eq('grade_id', currentUser!.ids.gradeId!)
        .eq('class_id', currentUser.ids.classId!)
        .eq('day_of_week', dayOfWeek)
        .order('start_at', ascending: true);

    // 3] Convert response to models
    return (res as List)
        .map(
          (e) =>
              ParentTimetableSessionModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
