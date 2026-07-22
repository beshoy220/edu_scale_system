import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/presentation/pages/teacher_assignments_page.dart';
import 'package:edu_scale/teacher/attendance/presentation/pages/teacher_attendance_page.dart';
import 'package:edu_scale/teacher/competitions/presentation/pages/teacher_competitions_page.dart';
import 'package:edu_scale/teacher/home_base/presentation/widgets/teacher_bottom_sheet_notifications.dart';
import 'package:edu_scale/teacher/home_base/presentation/widgets/teacher_tool_card.dart';
import 'package:edu_scale/teacher/library/presentation/pages/teacher_library_page.dart';
import 'package:edu_scale/teacher/quizzes/presentation/pages/teacher_quizzes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final currentUser = AccountManager.currentAccount();

  List teacherTools = [
    {
      'name': 'Assignments',
      'icon': CupertinoIcons.doc_text,
      'nav_to': TeacherAssignmentsPage(),
    },
    {
      'name': 'Quizzes',
      'icon': CupertinoIcons.doc,
      'nav_to': TeacherQuizzesPage(),
    },
    {
      'name': 'Attendance',
      'icon': CupertinoIcons.checkmark_seal,
      'nav_to': TeacherAttendancePage(),
    },
    {
      'name': 'Library',
      'icon': CupertinoIcons.book,
      'nav_to': TeacherLibraryPage(),
    },
    {
      'name': 'Competitions',
      'icon': CupertinoIcons.rocket,
      'nav_to': TeacherCompetitionsPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await AccountManager.currentAccount();

      PushNotificationsService.init();
      PushNotificationsService.topics.subscribeToTeacherTopics(currentUser!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(18, 18, 18, 32),

            decoration: BoxDecoration(
              color: AppStyle.colors.brown,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),

              image: DecorationImage(
                alignment: Alignment.topRight,
                image: AssetImage('assets/pics/shape_1.png'),
                fit: BoxFit.contain,
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppStyle.colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(CupertinoIcons.person),
                    ),

                    SizedBox(width: 10),

                    SizedBox(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: currentUser,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  'Good morning ${(snapshot.data!.gender == 'male') ? 'Mr.' : 'Mrs.'} ${snapshot.data!.displayName}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.colors.surface,
                                  ),
                                );
                              } else {
                                return Text(
                                  'Good morning Mr.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.colors.surface,
                                  ),
                                );
                              }
                            },
                          ),
                          Text(
                            'Teacher account',
                            style: TextStyle(color: AppStyle.colors.surface),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppStyle.colors.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) => const TeacherBottomSheetNotifications(),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.bell,
                    color: AppStyle.colors.surface,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Text(
                  'Teacher tools',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(CupertinoIcons.exclamationmark_circle),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: AppStyle.colors.surface,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                const Text(
                                  'Teacher Tools',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const Text(
                                  'The tools that help teachers manage their classes, assignments, quizzes, attendance, and more.',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                TeacherToolCard(
                  isWide: true,
                  title: 'Attendance',
                  subtitle: 'Register and view attendance in the school',
                  icon: CupertinoIcons.checkmark_seal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherAttendancePage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TeacherToolCard(
                        title: 'Assignments',
                        subtitle: 'Make and manage assignments for my classes',
                        icon: CupertinoIcons.doc_text,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherAssignmentsPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TeacherToolCard(
                        title: 'Quizzes',
                        subtitle: 'Make and manage quizzes for my classes',
                        icon: CupertinoIcons.doc,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherQuizzesPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TeacherToolCard(
                        color: AppStyle.colors.orange,
                        title: 'Competitions',
                        subtitle: '',
                        icon: CupertinoIcons.rocket,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherCompetitionsPage(),
                            ),
                          );
                        },
                        bottomWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TeacherToolCard(
                        title: 'Library',
                        subtitle: 'Upload files to the school library',
                        icon: CupertinoIcons.book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherLibraryPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // TextButton(
                //   onPressed: () async {
                //     final currentUser = await AccountManager.currentAccount();

                //     PushNotificationsService.sendNotification.sendByTopic(
                //       'teacher',
                //       // currentUser!.id,
                //       // '84b72cd1-1481-4acc-8c98-0edb1433dfba',
                //       'Test',
                //       'Test FCM notification',
                //     );
                //   },
                //   child: Text('Button'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
