import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_student_submission_model.dart';

class GetTeacherAssignmentStudentSubmissionRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherAssignmentStudentSubmissionModel>> getStudentSubmissions({
    required int assignmentId,
  }) async {
    // 1] query assignments submissions from supabase
    final response = await supabase
        .from('assignment_student_submissions')
        .select('''
      number_of_correct_questions,
      total_number_of_questions,
      users!student_id(name)
    ''')
        .eq('assignment_id', assignmentId);

    // 2] model response
    return (response as List)
        .map((e) => TeacherAssignmentStudentSubmissionModel.fromMap(e))
        .toList();
  }
}
