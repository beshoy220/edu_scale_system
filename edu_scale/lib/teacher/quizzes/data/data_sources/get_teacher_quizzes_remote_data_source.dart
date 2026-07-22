import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

import '../models/teacher_quiz_model.dart';

class GetTeacherQuizRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherQuizModel>> getCurrentQuizByTeacherId() async {
    // 1] get teacher id from loacal cache
    final currentUser = await AccountManager.currentAccount();
    final teacherId = currentUser!.id;

    // 2] query quizzes from supabase
    final response = await supabase
        .from('quizzes')
        .select('''
          id,
          topic,
          due_date,
          quiz_start_at,
          publish_status,
          number_of_questions,
          created_at,

          grades(
            id,
            name
          ),

          classes(
            id,
            nickname
          )

        ''')
        .eq('teacher_id', teacherId)
        .gte('due_date', DateTime.now().toIso8601String())
        .order('due_date', ascending: true);

    // 3] model response
    return (response as List).map((e) => TeacherQuizModel.fromMap(e)).toList();
  }

  Future<List<TeacherQuizModel>> getLast150PastQuizByTeacherId() async {
    // 1] get teacher id from loacal cache
    final currentUser = await AccountManager.currentAccount();
    final teacherId = currentUser!.id;

    // 2] query quizzes from supabase
    final response = await supabase
        .from('quizzes')
        .select('''
          id,
          topic,
          due_date,
          quiz_start_at,
          publish_status,
          number_of_questions,
          created_at,

          grades(
            id,
            name
          ),

          classes(
            id,
            nickname
          )

        ''')
        .eq('teacher_id', teacherId)
        .lt('due_date', DateTime.now().toIso8601String())
        .order('due_date', ascending: false)
        .limit(150);

    // 3] model response
    return (response as List).map((e) => TeacherQuizModel.fromMap(e)).toList();
  }
}
