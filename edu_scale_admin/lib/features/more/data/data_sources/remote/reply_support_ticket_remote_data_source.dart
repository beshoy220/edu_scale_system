import 'package:edu_scale_admin/core/shared_pref/cached_resources.dart';
import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale_admin/core/supabase_service/supabase_database_service.dart';

class ReplySupportTicketRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<void> replyToTicket({
    required int supportTicketId,
    required String reply,
  }) async {
    final schoolIdString = await CachedResources.getSchoolId();
    final userId = SupabaseAuthService().currentUser!.id;

    if (schoolIdString == null) {
      throw Exception('School ID not found.');
    }

    final schoolId = int.parse(schoolIdString);

    await _supabase.from('support_tickets_replies').insert({
      'school_id': schoolId,
      'support_ticket_id': supportTicketId,
      'user_id': userId,
      'user_replier_role': 'admin',
      'reply': reply,
    });

    await _supabase
        .from('support_tickets')
        .update({'status': 'in_progress'})
        .eq('id', supportTicketId);
  }
}
