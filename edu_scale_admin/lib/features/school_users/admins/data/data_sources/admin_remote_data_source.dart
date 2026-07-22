import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/admin_user_model.dart';

class AdminRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<List<AdminUserModel>> getAdmin() async {
    // Get cached school_id
    final schoolIdStr = await CachedResources.getSchoolId();
    if (schoolIdStr == null) {
      throw Exception('School ID not found. Please login again.');
    }

    final schoolId = int.tryParse(schoolIdStr);
    if (schoolId == null) {
      throw Exception('Invalid school ID format.');
    }

    // Fetch full admin data
    final response = await _supabase
        .from('users')
        .select('''
          id,
          school_id,
          name,
          email,
          phone,
          avatar_url,
          status,
          created_at
        ''')
        .eq('school_id', schoolId)
        .eq('role', 'admin')
        .order('email', ascending: true);

    // Convert to strongly typed model
    return (response as List)
        .map((json) => AdminUserModel.fromJson(json))
        .toList();
  }
}
