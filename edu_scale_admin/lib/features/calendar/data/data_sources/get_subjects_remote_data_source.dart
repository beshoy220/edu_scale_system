import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/teacher_model.dart';

class GetSubjectsRemoteDataSource {
  Future<List<TeacherModel>> get() async {
    // 1. Get school_id
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Fetch classes with grades
    final SupabaseDatabaseService db = SupabaseDatabaseService();

    final res = await db
        .from('users')
        .select('''
          id,
          name,
          email,
          user_profiles!user_profiles_user_id_fkey (
            subject_id,
            subjects (
              id,
              name
            )
          )
        ''')
        .eq('school_id', schoolId)
        .eq('role', 'teacher')
        .order('name');

    // 3. Convert to model
    return (res as List<dynamic>)
        .map((e) => TeacherModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
