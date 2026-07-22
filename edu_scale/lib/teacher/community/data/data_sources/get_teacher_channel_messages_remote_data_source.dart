import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/teacher/community/data/models/teacher_channel_message_model.dart';

class GetTeacherChannelMessagesRemoteDataSource {
  static Future<List<TeacherChannelMessageModel>> getLast100Messages({
    required int channelId,
  }) async {
    // 1] get the last 100 messages for the channel from the database
    SupabaseDatabaseService supabase = SupabaseDatabaseService();
    final response = await supabase
        .from('channel_messages')
        .select('''
      id,
      channel_id,
      attached_assignment_id,
      attached_quiz_id,
      message_text,
      created_at,
      users!channel_messages_sender_id_fkey (
        name,
        role
      )
    ''')
        .eq('channel_id', channelId)
        .order('created_at', ascending: false)
        .limit(100);

    // 2] convert the response to a list of TeacherChannelMessageModel objects
    return (response as List)
        .map(
          (e) => TeacherChannelMessageModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
