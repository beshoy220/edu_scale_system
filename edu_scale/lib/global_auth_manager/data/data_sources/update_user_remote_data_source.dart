import 'package:edu_scale/global_auth_manager/data/models/updated_user_model.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

class UserRemoteDataSource {
  final SupabaseDatabaseService db = SupabaseDatabaseService();

  Future<UpdatedUserModel> updateUserDataByUserUUID(
    String uuid,
    String gender,
    DateTime birthDay,
  ) async {
    final response = await db
        .from('users')
        .update({
          'gender': gender,
          'status': 'active',
          'birthday': birthDay.toIso8601String().split('T').first,
        })
        .eq('id', uuid)
        .select('''
  *,
  user_profiles!user_profiles_user_id_fkey(
    grade_id,
    class_id,
    subject_id,
    parent_id,
    student_id
  )
''')
        .single();
    // print('RES$response');
    return UpdatedUserModel.fromMap(response);
  }
}
