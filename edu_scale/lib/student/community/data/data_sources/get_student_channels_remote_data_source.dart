import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/community/data/models/student_channel_model.dart';

class GetStudentChannelsRemoteDataSource {
  Future<List<StudentChannelModel>> getStudentChannels() async {
    // 1] Get current student
    final currentUser = await AccountManager.currentAccount();

    final supabase = SupabaseDatabaseService();
    // 2] Get channels for the student's school, grade and class
    final response = await supabase
        .from('channels')
        .select('''
          id,
          school_id,
          grade_id(id, name),
          class_id(id, nickname)
        ''')
        .eq('school_id', currentUser!.schoolId)
        .or(
          'grade_id.is.null,'
          'and(grade_id.eq.${currentUser.ids.gradeId},class_id.is.null),'
          'and(grade_id.eq.${currentUser.ids.gradeId},class_id.eq.${currentUser.ids.classId})',
        );

    // 3] model response
    return response.map((e) => StudentChannelModel.fromJson(e)).toList();
  }
}
