import '../../../../../core/shared_pref/cached_resources.dart';
import '../../../../../core/supabase_service/supabase_database_service.dart';
import '../../models/support_ticket_model.dart';

class GetSupportTicketsRemoteDataSource {
  final SupabaseDatabaseService _supabase = SupabaseDatabaseService();

  Future<List<SupportTicket>> getSupportTickets({
    required int from,
    required int to,
  }) async {
    final schoolIdString = await CachedResources.getSchoolId();

    if (schoolIdString == null) {
      throw Exception('School ID not found in cache.');
    }

    final schoolId = int.tryParse(schoolIdString);

    if (schoolId == null) {
      throw Exception('School ID is not valid.');
    }

    final ticketsResponse = await _supabase
        .from('support_tickets')
        .select()
        .eq('school_id', schoolId)
        .order('created_at', ascending: false)
        .range(from, to);

    final tickets = List<Map<String, dynamic>>.from(ticketsResponse);

    if (tickets.isEmpty) return [];

    final ticketIds = tickets.map((e) => e['id']).toList();

    final repliesResponse = await _supabase
        .from('support_tickets_replies')
        .select()
        .eq('school_id', schoolId)
        .inFilter('support_ticket_id', ticketIds)
        .order('created_at', ascending: true);

    final replies = List<Map<String, dynamic>>.from(repliesResponse);

    final Map<int, List<SupportTicketReply>> repliesMap = {};

    for (final reply in replies) {
      final model = SupportTicketReply.fromMap(reply);

      repliesMap.putIfAbsent(model.supportTicketId, () => []);

      repliesMap[model.supportTicketId]!.add(model);
    }

    return tickets.map((ticket) {
      return SupportTicket.fromMap(ticket, repliesMap[ticket['id']] ?? []);
    }).toList();
  }
}
