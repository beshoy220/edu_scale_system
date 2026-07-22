import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/library/data/models/student_subjects_based_on_timetable_model.dart';

class GetStudentSubjectsBasedOnTimetableRemoteDataSource {
  final SupabaseDatabaseService _client = SupabaseDatabaseService();

  Future<List<StudentSubjectsBasedOnTimetableModel>>
  getStudentSubjectsBasedOnTimetable() async {
    final currentUser = await AccountManager.currentAccount();
    final gradeId = currentUser!.ids.gradeId;
    final classId = currentUser.ids.classId;

    final response = await _client.rpc(
      'get_grade_class_subjects',
      params: {'p_grade_id': gradeId, 'p_class_id': classId},
    );

    return (response as List)
        .map(
          (json) => StudentSubjectsBasedOnTimetableModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
