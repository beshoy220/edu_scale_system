import 'package:edu_scale_admin/core/shared_pref/cached_resources.dart';
import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';

import '../model/parent_user_model.dart';

class GetParentsRemoteDataSource {
  Future<List<ParentUserModel>> getParentsByClassId({
    required int classId,
  }) async {
    // 1. Get school_id
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    SupabaseDatabaseService db = SupabaseDatabaseService();

    final res = await db
        .from('users')
        .select('''
          name,
          email,
          phone,
          status,
          user_profiles!user_profiles_user_id_fkey!inner(student_id(name), class_id(nickname))
        ''')
        .eq('role', 'parent')
        .eq('school_id', schoolId)
        .eq('user_profiles.class_id', classId)
        .order('name', ascending: true);

    // 3. Convert to model
    return (res as List<dynamic>)
        .map((e) => ParentUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
