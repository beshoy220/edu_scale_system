import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

import '../models/teacher_assignment_model.dart';

class GetTeacherAssignmentRemoteDataSource {
  final SupabaseDatabaseService supabase = SupabaseDatabaseService();

  Future<List<TeacherAssignmentModel>> getCurrentAssignmentByTeacherId() async {
    // 1] get teacher id from loacal cache
    final currentUser = await AccountManager.currentAccount();
    final teacherId = currentUser!.id;

    // 2] query assignments from supabase
    final response = await supabase
        .from('assignments')
        .select('''
          id,
          topic,
          due_date,
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
    return (response as List)
        .map((e) => TeacherAssignmentModel.fromMap(e))
        .toList();
  }

  Future<List<TeacherAssignmentModel>>
  getLast150PastAssignmentByTeacherId() async {
    // 1] get teacher id from loacal cache
    final currentUser = await AccountManager.currentAccount();
    final teacherId = currentUser!.id;

    // 2] query assignments from supabase
    final response = await supabase
        .from('assignments')
        .select('''
          id,
          topic,
          due_date,
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
    return (response as List)
        .map((e) => TeacherAssignmentModel.fromMap(e))
        .toList();
  }
}
