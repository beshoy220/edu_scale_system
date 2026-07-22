import 'package:flutter/material.dart';

import '../../../../../core/shared_pref/cached_resources.dart';
import '../../../../../core/supabase_service/supabase_database_service.dart';

class SetUpSchool {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  void updateSchoolData(Map<String, dynamic> data) async {
    String? domain = await CachedResources.getSchoolDomain();
    await _supabase
        .from('schools')
        .update(data)
        .eq('school_domain', domain.toString());
  }

  Future<List<Map<String, dynamic>>> setGrade(List<String> grades) async {
    // 1. Get school_id from cache (returns Future<String?>)
    final schoolIdString = await CachedResources.getSchoolId();

    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Build the list of rows (each as a map)
    final List<Map<String, dynamic>> rows = grades
        .map((name) => {'school_id': schoolId, 'name': name})
        .toList();

    // 3. Insert all rows in one call
    final res = await _supabase.from('grades').insert(rows).select();
    return res;
  }

  Future<void> setClasses({
    required List<Map<String, dynamic>> gradesList,
    required Map<String, List<String>> selectedClassesPerGrade,
  }) async {
    // 1. Get school_id from cache
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }
    // 2. Build a map from grade name → grade id using the provided list
    final Map<String, int> gradeNameToId = {};
    for (final grade in gradesList) {
      final name = grade['name'] as String;
      final id = grade['id'] as int;
      gradeNameToId[name] = id;
    }

    // 3. Prepare class rows
    final List<Map<String, dynamic>> classRows = [];

    for (final entry in selectedClassesPerGrade.entries) {
      final gradeName = entry.key;
      final classNames = entry.value;

      final gradeId = gradeNameToId[gradeName];
      if (gradeId == null) {
        debugPrint(
          'Warning: Grade "$gradeName" not found in the provided grades list. Skipping.',
        );
        continue;
      }

      for (final className in classNames) {
        classRows.add({
          'school_id': schoolId,
          'grade_id': gradeId,
          'name': className,
          'nickname':
              className, // We set the class nickname as className to prevent null values and reduce errors
        });
      }
    }

    if (classRows.isEmpty) {
      debugPrint('No classes to insert.');
      return;
    }

    // 4. Bulk insert
    await _supabase.from('classes').insert(classRows).select();
  }

  Future<void> setSubjects(List<String> subjects) async {
    // 1. Get school_id from cache (returns Future<String?>)
    final schoolIdString = await CachedResources.getSchoolId();

    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final int? schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer: $schoolIdString');
    }

    // 2. Build the list of rows (each as a map)
    final List<Map<String, dynamic>> rows = subjects
        .map((name) => {'school_id': schoolId, 'name': name})
        .toList();

    // 3. Insert all rows in one call
    await _supabase.from('subjects').insert(rows).select();
  }

  Future<void> setChannels() async {
    final schoolIdString = await CachedResources.getSchoolId();
    final schoolId = int.parse(schoolIdString!);

    final List<Map<String, dynamic>> channels = [];

    // 1. School channel
    channels.add({'school_id': schoolId, 'grade_id': null, 'class_id': null});

    // 2. Grade channels
    final grades = await _supabase
        .from('grades')
        .select('id')
        .eq('school_id', schoolId);

    for (final grade in grades) {
      channels.add({
        'school_id': schoolId,
        'grade_id': grade['id'],
        'class_id': null,
      });
    }

    // 3. Class channels
    final classes = await _supabase
        .from('classes')
        .select('id, grade_id')
        .eq('school_id', schoolId);

    for (final classroom in classes) {
      channels.add({
        'school_id': schoolId,
        'grade_id': classroom['grade_id'],
        'class_id': classroom['id'],
      });
    }

    // 4. Bulk insert channels
    await _supabase.from('channels').insert(channels);
  }
}
