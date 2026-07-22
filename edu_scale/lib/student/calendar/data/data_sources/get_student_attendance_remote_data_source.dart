import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/calendar/data/models/student_attendance_model.dart';

class GetStudentAttendanceRemoteDataSource {
  Future<StudentAttendanceModel?> getAttendance({
    required DateTime date,
  }) async {
    // 1] Get current student
    final currentUser = await AccountManager.currentAccount();

    final supabase = SupabaseDatabaseService();

    // 2] Format date as yyyy-MM-dd
    final attendanceDate =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    // 3] Get attendance
    final response = await supabase
        .from('attendance')
        .select('''
          id,
          taken_by,
          status,
          reason,
          created_at
        ''')
        .eq('student_id', currentUser!.id)
        .eq('attendance_date', attendanceDate)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return StudentAttendanceModel.fromJson(response);
  }
}
