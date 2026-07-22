import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_upload_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thrown when the upload fails for any reason — a missing cached
/// account, or a Supabase error.
class TeacherAssignmentUploadException implements Exception {
  final String message;
  const TeacherAssignmentUploadException(this.message);

  @override
  String toString() => message;
}

/// Uploads a [TeacherAssignmentUploadModel] to Supabase.
///
/// Pulls the teacher/school/subject ids from the currently cached
/// account, then inserts the assignment row followed by its question
/// rows.
class TeacherAssignmentUploadRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> upload(TeacherAssignmentUploadModel model) async {
    final currentAccount = await AccountManager.currentAccount();
    if (currentAccount == null) {
      throw const TeacherAssignmentUploadException(
        'No signed-in account was found.',
      );
    }

    final teacherId = currentAccount.id;
    final schoolId = currentAccount.schoolId;
    final subjectId = currentAccount.ids.subjectId ?? 0;

    try {
      final assignmentResponse = await _supabase
          .from('assignments')
          .insert(
            model.toAssignmentJson(
              schoolId: schoolId,
              teacherId: teacherId,
              subjectId: subjectId,
            ),
          )
          .select('id')
          .single();

      final int assignmentId = assignmentResponse['id'];

      final questionsJson = model.toQuestionsJson(
        assignmentId: assignmentId,
        schoolId: schoolId,
      );

      await _supabase.from('assignment_questions').insert(questionsJson);
    } catch (e) {
      throw TeacherAssignmentUploadException(
        'Failed to upload assignment: $e',
      );
    }
  }
}
