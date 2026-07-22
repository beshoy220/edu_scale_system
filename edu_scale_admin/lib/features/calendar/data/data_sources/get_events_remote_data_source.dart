import '../../../../../../core/supabase_service/supabase_database_service.dart';
import '../../../../../core/shared_pref/cached_resources.dart';
import '../models/event_model.dart';

class GetEventsRemoteDataSource {
  // This method fetches events for a given date, including events that are
  // within 30 days before and after the provided date.
  Future<List<EventModel>> getByDateRange(DateTime date) async {
    final schoolIdString = await CachedResources.getSchoolId();

    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final schoolId = int.tryParse(schoolIdString);

    if (schoolId == null) {
      throw Exception('Invalid School ID: $schoolIdString');
    }

    // 30 days before and after the provided date
    final startDate = date.subtract(const Duration(days: 30));
    final endDate = date.add(const Duration(days: 30));

    final formattedStartDate = startDate.toIso8601String().split('T').first;
    final formattedEndDate = endDate.toIso8601String().split('T').first;

    final db = SupabaseDatabaseService();

    final res = await db
        .from('events')
        .select('*, event_targets(id, grade_id, class_id, subject_id, role)')
        .eq('school_id', schoolId)
        .gte('day_date', formattedStartDate)
        .lte('day_date', formattedEndDate)
        .order('day_date')
        .order('start_time');

    return (res as List<dynamic>)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
