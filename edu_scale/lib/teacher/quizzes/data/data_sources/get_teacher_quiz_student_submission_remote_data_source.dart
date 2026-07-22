import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_student_submission_model.dart';

class GetTeacherQuizStudentSubmissionRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherQuizStudentSubmissionModel>> getStudentSubmissions({
    required int quizId,
  }) async {
    // 1] query quizzes submissions from supabase
    final response = await supabase
        .from('quiz_student_submissions')
        .select('''
      number_of_correct_questions,
      total_number_of_questions,
      users!student_id(name)
    ''')
        .eq('quiz_id', quizId);

    // 2] model response
    return (response as List)
        .map((e) => TeacherQuizStudentSubmissionModel.fromMap(e))
        .toList();
  }
}
