import '../../../../../../core/supabase_service/supabase_database_service.dart';

// For deleting an event with event target we need to delete by CASCADE in SQL
class DeleteEventRemoteDataSource {
  Future<void> deleteEvent(int eventId) async {
    final db = SupabaseDatabaseService();

    await db.from('events').delete().eq('id', eventId);
  }
}
