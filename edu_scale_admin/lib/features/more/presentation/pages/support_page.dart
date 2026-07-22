import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';

// import '../providers/ticket_provider.dart';
// import '../providers/reply_support_ticket_provider.dart';
// import '../widgets/ticket_widget.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<SupportTicketsProvider>().fetchTickets();
  //   });

  //   _scrollController.addListener(_onScroll);
  // }

  // void _onScroll() {
  //   if (!_scrollController.hasClients) return;

  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 300) {
  //     context.read<SupportTicketsProvider>().fetchTickets();
  //   }
  // }

  // Future<void> _openReplyDialog(int ticketId) async {
  //   final controller = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       final replyProvider = context.watch<ReplySupportTicketProvider>();

  //       return AlertDialog(
  //         constraints: BoxConstraints(minWidth: 800),
  //         backgroundColor: AppStyle.colors.surface,
  //         title: const Text('Reply to Ticket'),
  //         content: TextField(
  //           controller: controller,
  //           maxLines: 5,
  //           decoration: const InputDecoration(hintText: 'Write your reply...'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(dialogContext),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: replyProvider.isLoading
  //                 ? null
  //                 : () async {
  //                     final success = await context
  //                         .read<ReplySupportTicketProvider>()
  //                         .reply(
  //                           supportTicketId: ticketId,
  //                           reply: controller.text.trim(),
  //                         );

  //                     if (!context.mounted) return;

  //                     Navigator.pop(dialogContext);

  //                     if (success) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                           content: Text('Reply sent successfully'),
  //                         ),
  //                       );

  //                       context.read<SupportTicketsProvider>().refresh();
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text(
  //                             context
  //                                     .read<ReplySupportTicketProvider>()
  //                                     .errorMessage ??
  //                                 'Failed to send reply',
  //                           ),
  //                         ),
  //                       );
  //                     }
  //                   },
  //             child: replyProvider.isLoading
  //                 ? const SizedBox(
  //                     width: 18,
  //                     height: 18,
  //                     child: CircularProgressIndicator(strokeWidth: 2),
  //                   )
  //                 : const Text('Send'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _scrollController
  //     ..removeListener(_onScroll)
  //     ..dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<SupportTicketsProvider>();

    return SingleChildScrollView(
      // controller: _scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help & Support'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Contact EduScale support team'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),
              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: const SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'If you are facing any problem or want to contact our team just'
                    .tr(),
              ),
              TextButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse('https://tally.so'),
                    mode: LaunchMode.platformDefault,
                  );
                },
                child: Text('click here'.tr()),
              ),
            ],
          ),

          // if (provider.isLoading && provider.tickets.isEmpty)
          //   const LinearProgressIndicator()
          // else if (provider.error != null && provider.tickets.isEmpty)
          //   Text(provider.error!, style: TextStyle(color: AppStyle.colors.red))
          // else if (provider.tickets.isEmpty)
          //   const Padding(
          //     padding: EdgeInsets.symmetric(vertical: 60),
          //     child: Center(
          //       child: Text(
          //         'It seems that nobody has submitted a support ticket.',
          //       ),
          //     ),
          //   )
          // else
          //   Column(
          //     children: [
          //       ListView.separated(
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemCount: provider.tickets.length,
          //         separatorBuilder: (_, __) => const SizedBox(height: 8),
          //         itemBuilder: (context, index) {
          //           final ticket = provider.tickets[index];

          //           return TicketWidget(
          //             ticket: ticket,
          //             onReply: () => _openReplyDialog(ticket.id),
          //           );
          //         },
          //       ),

          //       const SizedBox(height: 16),

          //       /// Bottom loading (pagination)
          //       if (provider.isLoading && provider.tickets.isNotEmpty)
          //         const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 12),
          //           child: LinearProgressIndicator(),
          //         ),

          //       /// End indicator
          //       if (!provider.hasMore && provider.tickets.isNotEmpty)
          //         Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 12),
          //           child: Text(
          //             'All tickets loaded',
          //             style: AppStyle.theme.primaryTextTheme.bodySmall,
          //           ),
          //         ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
