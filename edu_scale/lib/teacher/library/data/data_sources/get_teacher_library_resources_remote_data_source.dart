import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/supabase_service/supabase_client.dart';
import 'package:edu_scale/teacher/library/data/models/teacher_library_resources_item_model.dart';

class GetTeacherLibraryResourcesRemoteDataSource {
  Future<List<TeacherLibraryResourcesItemModel>> getLatestResources({
    required int gradeId,
    required int? classId,
  }) async {
    final currentUser = await AccountManager.currentAccount();
    String teacherId = currentUser!.id;

    final response = await SupabaseConfig.client
        .from('library_resources')
        .select()
        .eq('teacher_id', teacherId)
        .eq('grade_id', gradeId)
        .or('class_id.is.null,class_id.eq.$classId')
        .order('created_at', ascending: false)
        .limit(150);

    return (response as List)
        .map((e) => TeacherLibraryResourcesItemModel.fromJson(e))
        .toList();
  }
}
