import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/class_for_students_model.dart';

class GetClassesForStudentsRemoteDataSource {
  Future<List<ClassForStudentsModel>> get() async {
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
        .from('classes')
        .select('''
          id,
          name,
          nickname,
          grades (
            id,
            name
          )
        ''')
        .eq('school_id', schoolId)
        .order('grade_id')
        .order('nickname', ascending: true);

    // 3. Convert to model
    return (res as List<dynamic>)
        .map((e) => ClassForStudentsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
