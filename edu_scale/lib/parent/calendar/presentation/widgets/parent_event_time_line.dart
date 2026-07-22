import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/calendar/data/models/parent_event_model.dart';
import 'package:flutter/cupertino.dart';

class ParentEventsTimeLine extends StatelessWidget {
  final List<ParentEventModel> events;

  const ParentEventsTimeLine({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No events scheduled for this day.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = events[index];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppStyle.colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                event.title,
                style: AppStyle.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (event.description.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  event.description,
                  style: AppStyle.theme.textTheme.bodyMedium,
                ),
              ],

              const SizedBox(height: 14),

              /// Time
              Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    size: 18,
                    color: AppStyle.colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                    style: AppStyle.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              /// Targets
              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: event.targets
              //       .map(
              //         (target) => Chip(
              //           backgroundColor: AppStyle.colors.green.withValues(
              //             alpha: .15,
              //           ),
              //           side: BorderSide.none,
              //           label: Text(
              //             _targetLabel(target),
              //             style: TextStyle(
              //               color: AppStyle.colors.green,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       )
              //       .toList(),
              // ),
            ],
          ),
        );
      },
    );
  }

  // String _targetLabel(EventTargetModel target) {
  //   if (target.role != null && target.role != 'All') {
  //     return target.role!;
  //   }

  //   if (target.subjectId != null && target.subjectId != 0) {
  //     return 'Subject';
  //   }

  //   if (target.classId != null && target.classId != 0) {
  //     return 'Class';
  //   }

  //   if (target.gradeId != null && target.gradeId != 0) {
  //     return 'Grade';
  //   }

  //   return 'School';
  // }

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
