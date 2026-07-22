import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/calendar/data/models/student_time_table_session_model.dart';
import 'package:flutter/material.dart';

class StudentTimeTableTimeLine extends StatelessWidget {
  final List<StudentTimetableSessionModel> sessions;

  const StudentTimeTableTimeLine({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No sessions scheduled for this day.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final session = sessions[index];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.subject,
                        style: AppStyle.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Teacher: ${session.teacher}',
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
