import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/parent/quizzes/data/models/parent_past_quiz_model.dart';

class GetParentPastQuizzesRemoteDataSource {
  Future<List<ParentPastQuizModel>> getLast150PastQuizzes() async {
    final currentUser = await AccountManager.currentAccount();
    String studentId = currentUser!.ids.studentId!;
    int gradeId = currentUser.ids.gradeId!;
    int classId = currentUser.ids.classId!;

    final response = await SupabaseDatabaseService()
        .from('quizzes')
        .select('''
          id,
          teacher_id(name),
          subject_id(name),
          topic,
          number_of_questions,
          quiz_start_at,
          due_date,
          quiz_student_submissions!left(
            id,
            number_of_correct_questions,
            total_number_of_questions,
            created_at
          )
        ''')
        .eq('publish_status', 'published')
        .eq('grade_id', gradeId)
        .or('class_id.eq.$classId,class_id.is.null')
        .eq('quiz_student_submissions.student_id', studentId)
        .lt('due_date', DateTime.now().toIso8601String())
        .order('due_date', ascending: false)
        .limit(150);

    return (response as List<dynamic>)
        .map((e) => ParentPastQuizModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
