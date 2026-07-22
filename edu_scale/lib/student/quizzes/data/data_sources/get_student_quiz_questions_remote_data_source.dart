import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_questions_model.dart';

class GetStudentQuizQuestionsRemoteDataSource {
  final SupabaseDatabaseService _client = SupabaseDatabaseService();

  Future<List<StudentQuizQuestionsModel>> getQuizQuestions({
    required int quizId,
  }) async {
    final response = await _client
        .from('quiz_questions')
        .select()
        .eq('quiz_id', quizId)
        .order('question_order');

    return response
        .map((row) => StudentQuizQuestionsModel.fromMap(row))
        .toList();
  }
}
