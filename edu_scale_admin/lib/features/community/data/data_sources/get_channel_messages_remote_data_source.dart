import '../../../../core/supabase_service/supabase_database_service.dart';
import '../models/channel_message_model.dart';

class GetChannelMessagesRemoteDataSource {
  static Future<List<ChannelMessageModel>> get({required int channelId}) async {
    final supabase = SupabaseDatabaseService();

    final response = await supabase
        .from('channel_messages')
        .select('*, sender_id(id, name, role)')
        .eq('channel_id', channelId)
        .order('created_at', ascending: true)
        .limit(100);

    return (response as List)
        .map((e) => ChannelMessageModel.fromJson(e))
        .toList();
  }
}
