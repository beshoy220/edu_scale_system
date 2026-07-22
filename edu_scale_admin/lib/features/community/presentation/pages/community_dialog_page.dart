import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/push_notification_service/push_notification_service.dart';
import 'package:edu_scale_admin/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/community/data/models/channel_message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/channel_model.dart';
import '../providers/channels_provider.dart';
import '../providers/channel_message_provider.dart';

class CommunityDialogPage extends StatefulWidget {
  const CommunityDialogPage({super.key});

  @override
  State<CommunityDialogPage> createState() => _CommunityDialogPageState();
}

class _CommunityDialogPageState extends State<CommunityDialogPage> {
  ChannelModel? selectedChannel;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelsProvider>().getChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChannelsProvider>();
    final messageProvider = context.watch<ChannelMessagesProvider>();

    return AlertDialog(
      constraints: BoxConstraints(minWidth: 2000),
      backgroundColor: AppStyle.colors.surface,

      content: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(
                    right: BorderSide(color: AppStyle.colors.grey),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(CupertinoIcons.back),
                        ),
                        Text(
                          'Community'.tr(),
                          style: AppStyle.theme.primaryTextTheme.titleLarge,
                        ),
                      ],
                    ),

                    if (provider.isLoading) Text('Loading channels...'.tr()),

                    if (provider.errorMessage != null)
                      Center(child: Text(provider.errorMessage!)),

                    if (provider.channels.isEmpty && !provider.isLoading)
                      Center(child: Text('No channels found'.tr())),

                    if (provider.channels.isNotEmpty && !provider.isLoading)
                      ...provider.channels.map(
                        (channel) => InkWell(
                          hoverColor: Colors.transparent,
                          onTap: () {
                            messageProvider.clearMessages();
                            messageProvider.getMessages(channelId: channel.id);

                            setState(() {
                              selectedChannel = channel;
                            });
                          },

                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: AppStyle.colors.grey,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  CupertinoIcons.person_3,
                                  color: AppStyle.colors.black,
                                ),
                              ),

                              SizedBox(width: 16),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    channel.name.tr(),
                                    style: AppStyle
                                        .theme
                                        .primaryTextTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Click to view'.tr(),
                                    style: AppStyle
                                        .theme
                                        .primaryTextTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (selectedChannel == null)
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble_2,
                      size: 64,
                      color: AppStyle.colors.black.withAlpha(200),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select a channel to view details'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          if (selectedChannel != null)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            CupertinoIcons.person_3,
                            color: AppStyle.colors.black,
                          ),
                        ),

                        SizedBox(width: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedChannel != null
                                  ? selectedChannel!.name.tr()
                                  : 'Channel Name'.tr(),
                              style: AppStyle.theme.primaryTextTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Channel details and description go here.'.tr(),
                              style: AppStyle.theme.primaryTextTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          if (messageProvider.isLoading)
                            Expanded(child: Text('Loading chat...'.tr())),

                          if (messageProvider.errorMessage != null)
                            Expanded(
                              child: Text(messageProvider.errorMessage!),
                            ),

                          if (messageProvider.messages.isEmpty &&
                              !messageProvider.isLoading)
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 12),
                                  Container(
                                    // height: 100,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppStyle.colors.grey,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      'No messages yet. Start the conversation by sending a message below.'
                                          .tr(),
                                      style: AppStyle
                                          .theme
                                          .primaryTextTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (messageProvider.messages.isNotEmpty &&
                              !messageProvider.isLoading)
                            ChannelMessages(messages: messageProvider.messages),

                          // Expanded(
                          //   child: ChannelMessages(
                          //     channelId: selectedChannel!.id,
                          //   ),
                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hint: Text('Message...'.tr()),
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                              SizedBox(width: 8),

                              SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_messageController.text.isNotEmpty) {
                                      messageProvider.sendMessage(
                                        selectedChannel!.id,
                                        SupabaseAuthService().currentUser!.id,
                                        _messageController.text,
                                      );

                                      if (selectedChannel?.school != null &&
                                          selectedChannel?.grade == null &&
                                          selectedChannel?.classroom == null) {
                                        PushNotificationService.sendNotification
                                            .sendByTopic(
                                              'school-${selectedChannel?.school.id}',
                                              'Community • ${selectedChannel!.school.name} Channel',
                                              'Admin: ${_messageController.text}',
                                            );
                                      }

                                      if (selectedChannel?.school != null &&
                                          selectedChannel?.grade != null &&
                                          selectedChannel?.classroom == null) {
                                        PushNotificationService.sendNotification
                                            .sendByTopic(
                                              'school-${selectedChannel?.school.id}-grade-${selectedChannel?.grade?.id}',
                                              'Community • ${selectedChannel?.grade?.name} Channel',
                                              'Admin: ${_messageController.text}',
                                            );
                                      }

                                      if (selectedChannel?.school != null &&
                                          selectedChannel?.grade != null &&
                                          selectedChannel?.classroom != null) {
                                        PushNotificationService.sendNotification
                                            .sendByTopic(
                                              'school-${selectedChannel?.school.id}-grade-${selectedChannel?.grade?.id}-class-${selectedChannel?.classroom?.id}',
                                              'Community • ${selectedChannel?.classroom?.name} Channel',
                                              'Admin: ${_messageController.text}',
                                            );
                                      }

                                      _messageController.clear();
                                    }
                                  },
                                  child: Icon(
                                    CupertinoIcons.paperplane_fill,
                                    color: AppStyle.colors.surface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ChannelMessages extends StatefulWidget {
  final List<ChannelMessageModel> messages;

  const ChannelMessages({super.key, required this.messages});

  @override
  State<ChannelMessages> createState() => _ChannelMessagesState();
}

class _ChannelMessagesState extends State<ChannelMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(child: Text('No messages yet'.tr()));
    }

    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        reverse: false,
        padding: const EdgeInsets.all(16),
        itemCount: widget.messages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final message = widget.messages[index];

          return Align(
            alignment:
                (message.senderId == SupabaseAuthService().currentUser!.id)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (message.senderId == SupabaseAuthService().currentUser!.id)
                    ? AppStyle.colors.blue
                    : AppStyle.colors.grey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${message.senderName} - ${message.senderRole}',
                        style: AppStyle.theme.primaryTextTheme.bodySmall
                            ?.copyWith(
                              color:
                                  (message.senderId ==
                                      SupabaseAuthService().currentUser!.id)
                                  ? AppStyle.colors.surface
                                  : AppStyle.colors.black,
                            ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Text(
                    message.messageText,
                    style: AppStyle.theme.primaryTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          (message.senderId ==
                              SupabaseAuthService().currentUser!.id)
                          ? AppStyle.colors.surface
                          : AppStyle.colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // if (message.hasAssignment)
                      //   const Padding(
                      //     padding: EdgeInsets.only(right: 8),
                      //     child: Icon(Icons.assignment_outlined, size: 16),
                      //   ),

                      // if (message.hasQuiz)
                      //   const Padding(
                      //     padding: EdgeInsets.only(right: 8),
                      //     child: Icon(Icons.quiz_outlined, size: 16),
                      //   ),
                      Text(
                        _formatDate(message.createdAt),
                        style: AppStyle.theme.primaryTextTheme.bodySmall
                            ?.copyWith(
                              color:
                                  (message.senderId ==
                                      SupabaseAuthService().currentUser!.id)
                                  ? AppStyle.colors.surface.withAlpha(200)
                                  : AppStyle.colors.black.withAlpha(200),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
