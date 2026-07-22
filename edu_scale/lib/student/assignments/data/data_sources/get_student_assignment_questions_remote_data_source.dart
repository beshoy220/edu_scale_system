import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_questions_model.dart';

class GetStudentAssignmentQuestionsRemoteDataSource {
  final SupabaseDatabaseService _client = SupabaseDatabaseService();

  Future<List<StudentAssignmentQuestionsModel>> getAssignmentQuestions({
    required int assignmentId,
  }) async {
    final response = await _client
        .from('assignment_questions')
        .select()
        .eq('assignment_id', assignmentId)
        .order('question_order');

    return response
        .map((row) => StudentAssignmentQuestionsModel.fromMap(row))
        .toList();
  }
}
