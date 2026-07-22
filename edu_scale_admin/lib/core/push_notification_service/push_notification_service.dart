import 'package:edu_scale_admin/core/supabase_service/supabase_edge_functions_service.dart';

class PushNotificationService {
  static SendNotification sendNotification = SendNotification();
}

class SendNotification {
  final _supabase = SupabaseEdgeService();

  Future<void> sendByUserId(String userId, String title, String body) async {
    final response = await _supabase.invoke(
      functionName: 'send-fcm',
      body: {'user_id': userId, 'title': title, 'body': body},
    );

    if (response.status != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> sendByTopic(String topic, String title, String body) async {
    final response = await _supabase.invoke(
      functionName: 'send-fcm',
      body: {'topic': topic, 'title': title, 'body': body},
    );

    if (response.status != 200) {
      throw Exception(response.data);
    }
  }
}
