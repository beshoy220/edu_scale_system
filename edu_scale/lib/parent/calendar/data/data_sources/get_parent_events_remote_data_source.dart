import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/parent/calendar/data/models/parent_event_model.dart';
import '../../../../../../core/supabase_service/supabase_database_service.dart';

class GetParentEventsRemoteDataSource {
  // This method fetches events for a given date, including events that are
  // within 30 days before and after the provided date.
  Future<List<ParentEventModel>> getByDateRange(DateTime date) async {
    final currentUser = await AccountManager.currentAccount();
    int schoolId = currentUser!.schoolId;

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
        .map((e) => ParentEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
