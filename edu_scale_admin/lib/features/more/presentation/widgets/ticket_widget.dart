import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/support_ticket_model.dart';

class TicketWidget extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onReply;

  const TicketWidget({super.key, required this.ticket, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.title,
            style: AppStyle.theme.primaryTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(ticket.body),

          const SizedBox(height: 10),

          Text(
            '${ticket.createdAt.day.toString().padLeft(2, '0')}/${ticket.createdAt.month.toString().padLeft(2, '0')}/${ticket.createdAt.year} ${ticket.createdAt.hour.toString().padLeft(2, '0')}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
            style: AppStyle.theme.primaryTextTheme.bodySmall?.copyWith(
              color: AppStyle.colors.black.withAlpha(150),
            ),
          ),

          const SizedBox(height: 10),

          /// ================= TAGS =================
          Row(
            children: [
              _tag(ticket.label, AppStyle.colors.red),
              const SizedBox(width: 6),
              _tag('TK-${ticket.id}', AppStyle.colors.orange),
              const SizedBox(width: 6),
              _tag(ticket.status, AppStyle.colors.green),
            ],
          ),

          const SizedBox(height: 14),

          if (ticket.replies.isNotEmpty) ...[
            const Divider(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ticket.replies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.black.withAlpha(10),
                      borderRadius: BorderRadius.circular((24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 18,
                              color: AppStyle.colors.black.withAlpha(180),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              reply.userReplierRole.toUpperCase(),
                              style: AppStyle.theme.primaryTextTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// REPLY TEXT
                        Text(reply.reply),

                        const SizedBox(height: 4),

                        /// TIME
                        Text(
                          '${reply.createdAt.day.toString().padLeft(2, '0')}/${reply.createdAt.month.toString().padLeft(2, '0')}/${reply.createdAt.year} ${reply.createdAt.hour.toString().padLeft(2, '0')}:${reply.createdAt.minute.toString().padLeft(2, '0')}',
                          style: AppStyle.theme.primaryTextTheme.bodySmall
                              ?.copyWith(
                                color: AppStyle.colors.black.withAlpha(120),
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 12),

          /// ================= ACTIONS =================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply),
                label: const Text('Reply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
