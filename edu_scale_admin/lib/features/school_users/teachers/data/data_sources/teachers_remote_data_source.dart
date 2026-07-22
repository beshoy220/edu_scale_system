import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/teacher_user_model.dart';

class TeachersRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<List<TeacherUserModel>> getTeachers() async {
    final schoolIdStr = await CachedResources.getSchoolId();
    if (schoolIdStr == null) {
      throw Exception('School ID not found. Please login again.');
    }

    final schoolId = int.tryParse(schoolIdStr);
    if (schoolId == null) {
      throw Exception('Invalid school ID format.');
    }

    final response = await _supabase
        .from('users')
        .select('''
          id,
          school_id,
          name,
          email,
          phone,
          status,
          user_profiles!user_profiles_user_id_fkey!inner(subject_id(name))
        ''')
        .eq('school_id', schoolId)
        .eq('role', 'teacher')
        .order('email', ascending: true);

    return (response as List)
        .map((json) => TeacherUserModel.fromJson(json))
        .toList();
  }
}
