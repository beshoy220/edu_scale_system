import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import '../models/teacher_assignment_question_model.dart';

class GetTeacherAssignmentQuestionsRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherAssignmentQuestionModel>> getQuestions({
    required int assignmentId,
  }) async {
    final response = await supabase
        .from('assignment_questions')
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
        .eq('assignment_id', assignmentId)
        .order('question_order');

    return response
        .map<TeacherAssignmentQuestionModel>(
          (e) => TeacherAssignmentQuestionModel.fromMap(e),
        )
        .toList();
  }
}
