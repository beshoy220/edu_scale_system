import '../../../../../../core/supabase_service/supabase_database_service.dart';

class DeleteSessionRemoteDataSource {
  Future<void> deleteSession(int sessionId) async {
    final db = SupabaseDatabaseService();

    await db.from('timetable').delete().eq('id', sessionId);
  }
}
