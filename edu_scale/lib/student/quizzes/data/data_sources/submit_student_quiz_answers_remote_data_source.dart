import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

class SubmitStudentAnswersRemoteDataSource {
  final SupabaseDatabaseService _client = SupabaseDatabaseService();

  Future<void> submitStudentAnswers({
    required int quizId,
    required int numberOfCorrectQuestions,
    required int totalNumberOfQuestions,
    required List<Map<String, dynamic>> answers,
  }) async {
    final currentUser = await AccountManager.currentAccount();
    int schoolId = currentUser!.schoolId;
    String studentId = currentUser.id;

    final submission = await _client
        .from('quiz_student_submissions')
        .insert({
          'school_id': schoolId,
          'student_id': studentId,
          'quiz_id': quizId,
          'number_of_correct_questions': numberOfCorrectQuestions,
          'total_number_of_questions': totalNumberOfQuestions,
        })
        .select('id')
        .single();

    final submissionId = submission['id'] as int;

    final answersToInsert = answers.map((answer) {
      return {
        'school_id': schoolId,
        'submission_id': submissionId,
        'quiz_question_id': answer['quiz_question_id'],
        'answer': answer['answer'],
        'is_correct': answer['is_correct'],
      };
    }).toList();

    await _client.from('quiz_student_answers').insert(answersToInsert);
  }
}
