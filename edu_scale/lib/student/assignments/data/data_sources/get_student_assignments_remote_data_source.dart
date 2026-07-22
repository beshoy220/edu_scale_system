import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_model.dart';

class GetStudentCurrentAssignmentsRemoteDataSource {
  Future<List<StudentAssignmentModel>> getCurrentAssignments() async {
    final currentUser = await AccountManager.currentAccount();
    int gradeId = currentUser!.ids.gradeId!;
    int classId = currentUser.ids.classId!;
    String studentId = currentUser.id;

    SupabaseDatabaseService supabase = SupabaseDatabaseService();
    final response = await supabase
        .from('assignments')
        .select('''
      id,
      topic,
      number_of_questions,
      due_date,
      subject:subject_id(name),
      teacher:teacher_id(name),
      assignment_student_submissions(*)
    ''')
        .eq('publish_status', 'published')
        .gt('due_date', DateTime.now().toUtc().toIso8601String())
        .eq('grade_id', gradeId)
        .or('class_id.eq.$classId,class_id.is.null')
        .eq('assignment_student_submissions.student_id', studentId)
        .order('due_date', ascending: false);

    return response
        .map((json) => StudentAssignmentModel.fromJson(json))
        .toList();
  }

  Future<List<StudentAssignmentModel>> getPastAssignments() async {
    final currentUser = await AccountManager.currentAccount();
    int gradeId = currentUser!.ids.gradeId!;
    int classId = currentUser.ids.classId!;
    String studentId = currentUser.id;

    SupabaseDatabaseService supabase = SupabaseDatabaseService();
    final response = await supabase
        .from('assignments')
        .select('''
      id,
      topic,
      number_of_questions,
      due_date,
      subject:subject_id(name),
      teacher:teacher_id(name),
      assignment_student_submissions(*)
    ''')
        .eq('publish_status', 'published')
        .lt('due_date', DateTime.now().toUtc().toIso8601String())
        .eq('grade_id', gradeId)
        .or('class_id.eq.$classId,class_id.is.null')
        .eq('assignment_student_submissions.student_id', studentId)
        .limit(150)
        .order('due_date', ascending: false);

    return response
        .map((json) => StudentAssignmentModel.fromJson(json))
        .toList();
  }
}
