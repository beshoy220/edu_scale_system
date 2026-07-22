import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';

class AddEventRemoteDataSource {
  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime dayDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
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

    // 2. Get current user id
    final createdBy = await SupabaseAuthService().currentUser?.id;

    if (createdBy == null) {
      throw Exception('User ID not found in cache.');
    }

    // 3. Format date
    final formattedDate = dayDate.toIso8601String().split('T').first;

    // 4. Format time
    final formattedStartTime =
        '${startTime.hour.toString().padLeft(2, '0')}:'
        '${startTime.minute.toString().padLeft(2, '0')}:00';

    final formattedEndTime =
        '${endTime.hour.toString().padLeft(2, '0')}:'
        '${endTime.minute.toString().padLeft(2, '0')}:00';

    // 5. Insert
    final SupabaseDatabaseService db = SupabaseDatabaseService();

    await db.from('events').insert({
      'school_id': schoolId,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'day_date': formattedDate,
      'start_time': formattedStartTime,
      'end_time': formattedEndTime,
    });
  }
}
