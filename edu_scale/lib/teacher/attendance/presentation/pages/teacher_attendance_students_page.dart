import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/teacher_attendance_provider.dart';

class TeacherAttendanceStudentsPage extends StatefulWidget {
  final int gradeId;
  final int classId;
  final String title;

  const TeacherAttendanceStudentsPage({
    super.key,
    required this.gradeId,
    required this.classId,
    required this.title,
  });

  @override
  State<TeacherAttendanceStudentsPage> createState() =>
      _TeacherAttendanceStudentsPageState();
}

class _TeacherAttendanceStudentsPageState
    extends State<TeacherAttendanceStudentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherAttendanceProvider>().getStudentsByClassId(
        widget.classId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherAttendanceProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              SizedBox(width: 4),
              Text(widget.title),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Attendance for Today',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      provider.attendAll();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppStyle.colors.green,
                    ),
                    child: const Text('Attend all'),
                  ),
                ],
              ),
            ),

            Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return LinearProgressIndicator();
                }

                if (provider.errorMessage != null) {
                  return Text(
                    provider.errorMessage.toString(),
                    style: TextStyle(color: AppStyle.colors.red),
                  );
                }

                if (provider.studentsList == []) {
                  return Text('Class has no students');
                }

                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.studentsList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final student = provider.studentsList[index];

                      Color color = Colors.transparent;
                      String? label;

                      switch (student.attendanceStatus) {
                        case 'present':
                          color = AppStyle.colors.green;
                          label = 'Present';
                          break;

                        case 'absent':
                          color = AppStyle.colors.red;
                          label = 'Absent';
                          break;

                        case 'late':
                          color = AppStyle.colors.yellow;
                          label = 'Late';
                          break;

                        case 'excused':
                          color = AppStyle.colors.orange;
                          label = 'Excused';
                          break;
                      }

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          provider.changeAttendance(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: student.avatarUrl == null
                                    ? const Icon(Icons.person_outline)
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          student.avatarUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.studentName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      'Student',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              if (label != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: provider.hasUnsavedChanges
            ? FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                backgroundColor: AppStyle.colors.brown,
                foregroundColor: AppStyle.colors.surface,
                onPressed: () async {
                  // await provider.saveAttendance(widget.gradeId, widget.classId);

                  final currentUser = await AccountManager.currentAccount();

                  await PushNotificationsService.sendNotification.sendByTopic(
                    'school-${currentUser?.schoolId}-grade-${widget.gradeId}-class-${widget.classId}-parent',
                    'Attendance',
                    'Attendance has been taken! Click to view.',
                  );
                  print(
                    'school-${currentUser?.schoolId}-grade-${widget.gradeId}-class-${widget.classId}-parent',
                  );
                  // Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.check_mark_circled_solid),
                label: const Text('Save'),
              )
            : null,
      ),
    );
  }
}
