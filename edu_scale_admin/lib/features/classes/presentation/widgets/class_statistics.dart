import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/class_statistics_provider.dart';
import 'attendance_bar_chart.dart';

class ClassStatistics extends StatefulWidget {
  final int classId;

  const ClassStatistics({super.key, required this.classId});

  @override
  State<ClassStatistics> createState() => _ClassStatisticsState();
}

class _ClassStatisticsState extends State<ClassStatistics> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassStatisticsProvider>().getClassStatistics(
        classId: widget.classId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassStatisticsProvider>();

    final statistics = provider.statistics;

    if (provider.isLoading) {
      return LinearProgressIndicator();
    }

    if (provider.errorMessage != null) {
      return Text(
        provider.errorMessage!,
        style: TextStyle(color: AppStyle.colors.red),
      );
    }

    if (statistics == null) {
      return Center(child: Text('No statistics found'.tr()));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // QUICK STATS
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                title: 'Assignment Submissions'.tr(),
                value: statistics.assignmentSubmissionsCount.toString(),
              ),

              _StatCard(
                title: 'Quiz Submissions'.tr(),
                value: statistics.quizSubmissionsCount.toString(),
              ),

              _StatCard(
                title: 'Students'.tr(),
                value: statistics.students.length.toString(),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ATTENDANCE
          Text(
            'Attendance By Day'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          // Replace the old Wrap of _AttendanceCard widgets:
          AttendanceBarChart(
            data: {
              'Sat': AttendanceDayStats(
                present: statistics.attendanceByDay.sat.present,
                absent: statistics.attendanceByDay.sat.absent,
                late: statistics.attendanceByDay.sat.late,
                excused: statistics.attendanceByDay.sat.excused,
              ),
              'Sun': AttendanceDayStats(
                present: statistics.attendanceByDay.sun.present,
                absent: statistics.attendanceByDay.sun.absent,
                late: statistics.attendanceByDay.sun.late,
                excused: statistics.attendanceByDay.sun.excused,
              ),
              'Mon': AttendanceDayStats(
                present: statistics.attendanceByDay.mon.present,
                absent: statistics.attendanceByDay.mon.absent,
                late: statistics.attendanceByDay.mon.late,
                excused: statistics.attendanceByDay.mon.excused,
              ),
              'Tue': AttendanceDayStats(
                present: statistics.attendanceByDay.tue.present,
                absent: statistics.attendanceByDay.tue.absent,
                late: statistics.attendanceByDay.tue.late,
                excused: statistics.attendanceByDay.tue.excused,
              ),
              'Wed': AttendanceDayStats(
                present: statistics.attendanceByDay.wed.present,
                absent: statistics.attendanceByDay.wed.absent,
                late: statistics.attendanceByDay.wed.late,
                excused: statistics.attendanceByDay.wed.excused,
              ),
              'Thu': AttendanceDayStats(
                present: statistics.attendanceByDay.thu.present,
                absent: statistics.attendanceByDay.thu.absent,
                late: statistics.attendanceByDay.thu.late,
                excused: statistics.attendanceByDay.thu.excused,
              ),
              'Fri': AttendanceDayStats(
                present: statistics.attendanceByDay.fri.present,
                absent: statistics.attendanceByDay.fri.absent,
                late: statistics.attendanceByDay.fri.late,
                excused: statistics.attendanceByDay.fri.excused,
              ),
            },
          ),

          const SizedBox(height: 32),

          // ASSIGNMENTS
          Text(
            'Assignments By Subject'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          ...statistics.assignmentsBySubject.map(
            (assignment) => Container(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppStyle.colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.subjectName,
                        style: AppStyle.theme.primaryTextTheme.bodyMedium,
                      ),
                      Text(assignment.teacherName),
                    ],
                  ),
                  Text(assignment.assignmentMadeCount.toString()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // QUIZZES
          Text(
            'Quizzes By Subject'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          ...statistics.quizzesBySubject.map(
            (quiz) => Container(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppStyle.colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.subjectName,
                        style: AppStyle.theme.primaryTextTheme.bodyMedium,
                      ),
                      Text(quiz.teacherName),
                    ],
                  ),
                  Text(quiz.quizzesMadeCount.toString()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // STUDENTS
          Text('Students'.tr(), style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: statistics.students.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
            ),
            itemBuilder: (context, index) {
              final student = statistics.students[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppStyle.colors.grey),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: student.avatarUrl.isNotEmpty
                          ? NetworkImage(student.avatarUrl)
                          : null,
                      child: student.avatarUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        student.studentName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppStyle.colors.grey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),

          const SizedBox(height: 10),

          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
