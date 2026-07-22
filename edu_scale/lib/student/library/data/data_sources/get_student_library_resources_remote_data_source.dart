import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/student/library/data/models/student_library_resources_model.dart';

class GetStudentLibraryResourcesRemoteDataSource {
  Future<List<StudentLibraryResourceModel>> getResources(int subjectId) async {
    final currentUser = await AccountManager.currentAccount();
    final gradeId = currentUser!.ids.gradeId;
    final classId = currentUser.ids.classId;

    final response = await SupabaseDatabaseService()
        .from('library_resources')
        .select('''
          id,
          title,
          file_url,
          file_size_in_kb,
          file_type,
          created_at
        ''')
        .eq('subject_id', subjectId)
        .eq('grade_id', gradeId!)
        .eq('class_id', classId!)
        .eq('status', 'approved')
        .order('created_at', ascending: false)
        .limit(150);

    return (response as List)
        .map(
          (e) =>
              StudentLibraryResourceModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
