import 'package:edu_scale/core/supabase_service/supabase_client.dart';
import 'package:edu_scale/parent/home_base/data/models/parent_student_info_model.dart';

class GetStudentInfoForParentRemoteDataSource {
  Future<ParentStudentInfoModel> getStudentInfoByStudentId(
    String studentId,
  ) async {
    final response = await SupabaseConfig.client
        .from('users')
        .select()
        .eq('id', studentId)
        .single();

    return ParentStudentInfoModel.fromJson(response);
  }
}
