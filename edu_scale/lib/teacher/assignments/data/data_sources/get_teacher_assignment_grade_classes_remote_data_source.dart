import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_grade_class_model.dart';

class GetTeacherAssignmentGradeClassesRemoteDataSource {
  Future<List<TeacherAssignmentGradeClassModel>>
  getGradesAndClassesAssignedToTeacher() async {
    // 1] get teacher id from loacal cache
    final currentUser = await AccountManager.currentAccount();
    final teacherId = currentUser!.id;

    // 2] query
    SupabaseDatabaseService supabase = SupabaseDatabaseService();
    final response = await supabase.rpc(
      'get_teacher_grade_classes',
      params: {'p_teacher_id': teacherId},
    );

    // 3] model response
    return (response as List)
        .map<TeacherAssignmentGradeClassModel>(
          (e) => TeacherAssignmentGradeClassModel.fromMap(e),
        )
        .toList();
  }
}
