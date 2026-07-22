import 'package:flutter/material.dart';
import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/time_table_session_model.dart';

class TimeTableRemoteDataSource {
  Future<void> addSession({
    required int gradeId,
    required int classId,
    required int subjectId,
    required String teacherId,
    required int dayOfWeek, // 1 = saterday, 7 = friday
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    String? room,
  }) async {
    // 1. Get school_id
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not valid.');
    }

    // 2. Format times
    final formattedStart = formatTime(startTime);
    final formattedEnd = formatTime(endTime);

    // 3. Insert
    final SupabaseDatabaseService db = SupabaseDatabaseService();
    await db.from('timetable').insert({
      'school_id': schoolId,
      'grade_id': gradeId,
      'class_id': classId,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'day_of_week': dayOfWeek,
      'start_at': formattedStart,
      'end_at': formattedEnd,
      'room': room?.trim().isEmpty == true ? null : room,
    });
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<List<TimeTableSessionModel>> getSessions({
    required int gradeId,
    required int classId,
  }) async {
    // 1. Get school_id
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not valid.');
    }

    // 2. Query
    final SupabaseDatabaseService db = SupabaseDatabaseService();

    final res = await db
        .from('timetable')
        .select('''
          id,
          grade_id,
          class_id,
          subject_id,
          teacher_id,
          day_of_week,
          start_at,
          end_at,
          room,

          users!timetable_teacher_id_fkey (
            name
          ),

          subjects (
            name
          )
        ''')
        .eq('school_id', schoolId)
        .eq('grade_id', gradeId)
        .eq('class_id', classId)
        .order('day_of_week')
        .order('start_at');

    // 3. Convert to model
    return (res as List<dynamic>)
        .map((e) => TimeTableSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
