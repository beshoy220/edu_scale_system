import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:edu_scale/parent/home_base/data/models/parent_notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParentNotificationRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ParentNotificationModel>> getLast50Notifications() async {
    // 1] get user id from cached account
    CachedAccount? user = await AccountManager.currentAccount();
    String userId = user?.id ?? '';

    // 2] fetch last 50 notifications by userId from supabase
    final response = await _supabase
        .from('user_notifications')
        .select('id, title, body, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);

    // 3] model response
    return (response as List)
        .map(
          (e) => ParentNotificationModel.fromMap(Map<String, dynamic>.from(e)),
        )
        .toList();
  }
}
