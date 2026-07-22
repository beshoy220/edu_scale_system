import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/teacher/calendar/data/models/teacher_time_table_model.dart';
import '../../../../../../core/supabase_service/supabase_database_service.dart';

class GetTeacherTimeTableRemoteDataSource {
  // This method fetches all teacher's sessions in the timetable table
  Future<List<TeacherTimeTableModel>> getTimeTableSessions({
    required int dayOfWeek,
  }) async {
    final currentUser = await AccountManager.currentAccount();
    String teacherId = currentUser!.id;

    final supabase = SupabaseDatabaseService();

    final res = await supabase
        .from('timetable')
        .select('''
      id,
      subject_id,
      day_of_week,
      start_at,
      end_at,
      room,
      created_at,
      grade:grades(id, name),
      class:classes(id, nickname)
    ''')
        .eq('teacher_id', teacherId)
        .eq('day_of_week', dayOfWeek)
        .order('start_at', ascending: true);

    return (res as List<dynamic>)
        .map((e) => TeacherTimeTableModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
