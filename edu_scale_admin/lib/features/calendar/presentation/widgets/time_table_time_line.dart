import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/themes.dart';
import '../providers/time_table_provider.dart';

class TimeTableTimeline extends StatefulWidget {
  final int dayOfWeek; // 1..6 (Sat..Thu)

  const TimeTableTimeline({super.key, required this.dayOfWeek});

  @override
  State<TimeTableTimeline> createState() => _TimeTableTimelineState();
}

class _TimeTableTimelineState extends State<TimeTableTimeline> {
  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<TimeTableProvider>().sessions;

    final filteredSessions = sessions
        .where((s) => s.dayOfWeek == widget.dayOfWeek)
        .toList();

    if (filteredSessions.isEmpty) {
      return SizedBox(
        child: Center(
          child: Text(
            'No sessions for this day'.tr(),
            style: TextStyle(color: AppStyle.colors.black.withAlpha(180)),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: filteredSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final session = filteredSessions[index];

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  '${_formatTime(session.startAt)}\n${_formatTime(session.endAt)}',
                  textAlign: TextAlign.center,
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppStyle.colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index != sessions.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: AppStyle.colors.green,
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.subjectName!,
                            style: AppStyle.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Teacher: ${session.teacherName}',
                            style: AppStyle.theme.textTheme.bodyMedium,
                          ),

                          if (session.room != null &&
                              session.room!.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Room: ${session.room}',
                              style: AppStyle.theme.textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),

                      Align(
                        alignment: AlignmentGeometry.topRight,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: AppStyle.colors.surface,
                                  title: Text('Delete Session'.tr()),
                                  content: Text(
                                    'Are you sure you want to delete this session? This action cannot be undone.'
                                        .tr(),
                                    style: AppStyle
                                        .theme
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppStyle.colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 18,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel'.tr(),
                                        style: TextStyle(
                                          color: AppStyle.colors.black,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppStyle.colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 18,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<TimeTableProvider>()
                                            .deleteSession(session.id);

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'.tr()),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              CupertinoIcons.trash,
                              color: AppStyle.colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');

    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';

    hour %= 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }
}
