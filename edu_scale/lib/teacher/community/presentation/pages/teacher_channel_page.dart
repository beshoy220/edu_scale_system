import 'package:edu_scale/core/helper_functions/time_formatter.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/community/data/models/teacher_channel_model.dart';
import 'package:edu_scale/teacher/community/presentation/providers/teacher_channel_message_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherChannelPage extends StatefulWidget {
  const TeacherChannelPage({super.key, required this.channel});

  final TeacherChannelModel channel;

  @override
  State<TeacherChannelPage> createState() => _TeacherChannelPageState();
}

class _TeacherChannelPageState extends State<TeacherChannelPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherChannelMessagesProvider>().loadMessages(
        channelId: widget.channel.id,
      );
    });
  }

  String get channelName {
    if (widget.channel.grade == null) {
      return 'School Community';
    }

    if (widget.channel.classroom == null) {
      return widget.channel.grade!.name;
    }

    return '${widget.channel.grade!.name} • ${widget.channel.classroom!.nickname}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherChannelMessagesProvider>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.fromLTRB(8, 18, 8, 18),
              decoration: BoxDecoration(
                color: AppStyle.colors.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4), // Bottom shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppStyle.colors.grey,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Icon(CupertinoIcons.person_3),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channelName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Channel'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }

                  if (provider.messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppStyle.colors.grey,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.sender.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const SizedBox(height: 2),
                            Text(
                              message.sender.role,
                              style: TextStyle(
                                color: AppStyle.colors.black.withAlpha(100),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(message.messageText),
                            const SizedBox(height: 8),
                            Text(timeFormatter(message.createdAt.toString())),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                border: Border(
                  top: BorderSide(color: AppStyle.colors.onYellow),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 12),
                  Expanded(child: Text('Teachers cannot send messages yet.')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
