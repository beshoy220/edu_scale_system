import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../../../../../core/supabase_service/supabase_edge_functions_service.dart';

class CreateTeachersRemoteDataSource {
  final SupabaseEdgeService _edgeService = SupabaseEdgeService();

  Future<FunctionResponse> create(
    int subjectId,
    String subjectName,
    List<Map> usersList,
  ) async {
    // 1. Retrieve cached school_id
    final schoolIdStr = await CachedResources.getSchoolId();
    if (schoolIdStr == null) {
      throw Exception('School ID not found in cache. Please log in again.');
    }

    final schoolId = int.tryParse(schoolIdStr);
    if (schoolId == null) {
      throw Exception('Invalid school ID format.');
    }

    // 2. Call Supabase Invoke Edge Fuction
    final response = await _edgeService.invoke(
      functionName: 'create-teachers',
      body: {
        "school_id": schoolId,
        "subject_id": subjectId,
        "subject_name": subjectName,
        "users": usersList,
      },
    );

    // 3. Return raw JSON list or success or failed
    return response;
  }
}
