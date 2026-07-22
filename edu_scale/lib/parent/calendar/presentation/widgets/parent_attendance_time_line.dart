import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/calendar/data/models/parent_attendance_model.dart';
import 'package:flutter/material.dart';

class ParentAttendanceTimeLine extends StatelessWidget {
  final ParentAttendanceModel? attendance;

  const ParentAttendanceTimeLine({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    if (attendance == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(Icons.remove_circle_outline, color: AppStyle.colors.black),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('No attendance has been taken for this day.'),
            ),
          ],
        ),
      );
    }

    final color = _statusColor(attendance!.status);
    final title = _statusTitle(attendance!.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),

          if (attendance!.reason != null &&
              attendance!.reason!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              attendance!.reason!,
              style: TextStyle(
                color: AppStyle.colors.black.withValues(alpha: .7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'present':
        return AppStyle.colors.green;
      case 'late':
        return AppStyle.colors.yellow;
      case 'absent':
        return AppStyle.colors.red;
      case 'excused':
        return AppStyle.colors.orange;
      default:
        return AppStyle.colors.black;
    }
  }

  String _statusTitle(String status) {
    switch (status) {
      case 'present':
        return 'Present';
      case 'late':
        return 'Late';
      case 'absent':
        return 'Absent';
      case 'excused':
        return 'Excused';
      default:
        return status;
    }
  }
}
