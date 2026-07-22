import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import '../models/teacher_quiz_question_model.dart';

class GetTeacherQuizQuestionsRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherQuizQuestionModel>> getQuestions({
    required int quizId,
  }) async {
    final response = await supabase
        .from('quiz_questions')
        .select('''
          question_text,
          options_1,
          options_2,
          options_3,
          options_4,
          options_5,
          options_6,
          model_answer
        ''')
        .eq('quiz_id', quizId)
        .order('question_order');

    return response
        .map<TeacherQuizQuestionModel>(
          (e) => TeacherQuizQuestionModel.fromMap(e),
        )
        .toList();
  }
}
