import 'package:edu_scale_admin/core/supabase_service/supabase_edge_functions_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/shared_pref/cached_resources.dart';

class CreateStudentParentRemoteDataSource {
  Future<FunctionResponse> create({
    required int gradeId,
    required int classId,
    required List<Map<String, String>> users,
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

    // 2. Invoke edge function to create students and parents
    final SupabaseEdgeService edge = SupabaseEdgeService();

    final response = await edge.invoke(
      functionName: 'create-students-parents',
      body: {
        "school_id": schoolId,
        "grade_id": gradeId,
        "class_id": classId,
        "users": users,
      },
    );

    // 3. Return raw JSON list or success or failed
    return response;
  }
}

// Users Example:
//
// [
//     {
//       'student_name': 'Amar Ahmed',
//       'parent_name': 'Ahmed Sayed',
//       'parent_phone': '201239123938',
//     },
//     {
//       'student_name': 'Marina Nashed',
//       'parent_name': 'Mark Michael',
//       'parent_phone': '201239123938',
//     },
//   ],
