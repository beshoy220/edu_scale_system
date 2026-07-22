class SupportTicket {
  final int id;
  final String title;
  final String body;
  final String status;
  final String label;
  final DateTime createdAt;
  final List<SupportTicketReply> replies;

  SupportTicket({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.label,
    required this.createdAt,
    required this.replies,
  });

  factory SupportTicket.fromMap(
    Map<String, dynamic> map,
    List<SupportTicketReply> replies,
  ) {
    return SupportTicket(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      status: map['status'],
      label: map['label'],
      createdAt: DateTime.parse(map['created_at']),
      replies: replies,
    );
  }
}

class SupportTicketReply {
  final int id;
  final int supportTicketId;
  final String reply;
  final String userReplierRole;
  final DateTime createdAt;

  SupportTicketReply({
    required this.id,
    required this.supportTicketId,
    required this.reply,
    required this.userReplierRole,
    required this.createdAt,
  });

  factory SupportTicketReply.fromMap(Map<String, dynamic> map) {
    return SupportTicketReply(
      id: map['id'],
      supportTicketId: map['support_ticket_id'],
      reply: map['reply'],
      userReplierRole: map['user_replier_role'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
