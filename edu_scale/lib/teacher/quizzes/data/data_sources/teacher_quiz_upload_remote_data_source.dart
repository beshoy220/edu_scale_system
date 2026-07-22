import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_upload_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thrown when the upload fails for any reason — a missing cached
/// account, or a Supabase error.
class TeacherQuizUploadException implements Exception {
  final String message;
  const TeacherQuizUploadException(this.message);

  @override
  String toString() => message;
}

/// Uploads a [TeacherQuizUploadModel] to Supabase.
///
/// Pulls the teacher/school/subject ids from the currently cached
/// account, then inserts the Quiz row followed by its question
/// rows.
class TeacherQuizUploadRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> upload(TeacherQuizUploadModel model) async {
    final currentAccount = await AccountManager.currentAccount();
    if (currentAccount == null) {
      throw const TeacherQuizUploadException('No signed-in account was found.');
    }

    final teacherId = currentAccount.id;
    final schoolId = currentAccount.schoolId;
    final subjectId = currentAccount.ids.subjectId ?? 0;

    try {
      final quizResponse = await _supabase
          .from('quizzes')
          .insert(
            model.toQuizJson(
              schoolId: schoolId,
              teacherId: teacherId,
              subjectId: subjectId,
            ),
          )
          .select('id')
          .single();

      final int quizId = quizResponse['id'];

      final questionsJson = model.toQuestionsJson(
        quizId: quizId,
        schoolId: schoolId,
      );

      await _supabase.from('quiz_questions').insert(questionsJson);
    } catch (e) {
      throw TeacherQuizUploadException('Failed to upload quiz: $e');
    }
  }
}
