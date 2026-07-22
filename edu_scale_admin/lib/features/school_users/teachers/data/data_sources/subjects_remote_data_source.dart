import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale_admin/features/school_users/teachers/data/models/teacher_subject_model.dart';
import '../../../../../core/shared_pref/cached_resources.dart';

class SubjectsRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<List<TeacherSubjectModel>> getSubjects() async {
    final schoolIdStr = await CachedResources.getSchoolId();
    if (schoolIdStr == null) {
      throw Exception('School ID not found. Please login again.');
    }

    final schoolId = int.tryParse(schoolIdStr);
    if (schoolId == null) {
      throw Exception('Invalid school ID format.');
    }

    final response = await _supabase
        .from('subjects')
        .select('id, name')
        .eq('school_id', schoolId)
        .order('name', ascending: true);

    return (response as List)
        .map((json) => TeacherSubjectModel.fromJson(json))
        .toList();
  }
}
