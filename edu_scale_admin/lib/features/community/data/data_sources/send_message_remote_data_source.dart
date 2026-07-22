import '../../../../core/shared_pref/cached_resources.dart';
import '../../../../core/supabase_service/supabase_database_service.dart';

class SendMessageRemoteDataSource {
  Future<void> send(int channelId, String senderId, String messageText) async {
    final schoolIdString = await CachedResources.getSchoolId();
    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final schoolId = int.tryParse(schoolIdString);
    if (schoolId == null) {
      throw Exception('School ID is not a valid integer.');
    }

    final supabase = SupabaseDatabaseService();
    await supabase.from('channel_messages').insert({
      'channel_id': channelId,
      'sender_id': senderId,
      'message_text': messageText,
    });
  }
}
