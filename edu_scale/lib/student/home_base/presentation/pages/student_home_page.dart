import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/progress_manager/progress_manager.dart';
import 'package:edu_scale/core/progress_manager/progress_screens/weekly_streak_bottom_sheet.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/assignments/presentation/pages/student_assignments_page.dart';
import 'package:edu_scale/student/competitions/presentation/pages/student_competition_page.dart';
import 'package:edu_scale/student/home_base/presentation/widgets/student_bottom_sheet_notifications.dart';
import 'package:edu_scale/student/library/presentation/pages/student_library_page.dart';
import 'package:edu_scale/student/mr_every_thing/presentation/pages/student_mr_every_thing_page.dart';
import 'package:edu_scale/student/quizzes/presentation/pages/student_quizzes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List studentTools = [
    {
      'name': 'Assignments',
      'icon': CupertinoIcons.doc_text,
      'pic': 'assets/pics/openned_book.png',
      'nav_to': StudentAssignmentsPage(),
    },
    {
      'name': 'Quizzes',
      'icon': CupertinoIcons.doc,
      'pic': 'assets/pics/question_boy.png',
      'nav_to': StudentQuizzesPage(),
    },
    {
      'name': 'Library',
      'icon': CupertinoIcons.rocket,
      'pic': 'assets/pics/reading_girl_2.png',
      'nav_to': StudentLibraryPage(),
    },
    {
      'name': 'Mr. EveryThing',
      'icon': CupertinoIcons.creditcard,
      'pic': 'assets/pics/happy_ropot_2.png',
      'nav_to': StudentMrEveryThingPage(),
    },
  ];

  List competitions = [
    {
      'name': 'Solo competition',
      'description': 'Compete as a solo student',
      'pic': 'assets/pics/happy_winner.png',
      'nav_to': StudentCompetitionPage(),
    },
    {
      'name': 'Team competition',
      'description': 'Compete in a team with your friends',
      'pic': 'assets/pics/happy_team.png',
      'nav_to': StudentCompetitionPage(),
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await AccountManager.currentAccount();

      // We register streak and check if accuired badges each time the student opens the app
      ProgressManager.registerStreak(currentUser!.id);
      ProgressManager.checkBadgeReward(currentUser.id);

      PushNotificationsService.init();
      PushNotificationsService.topics.subscribeToStudentTopics(currentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppStyle.colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(CupertinoIcons.person),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: AccountManager.currentAccount(),
                            builder: (context, snapshot) {
                              return Text(
                                'Hi, ${snapshot.data?.displayName ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppStyle.colors.surface,
                                ),
                              );
                            },
                          ),
                          Text(
                            'Student account',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppStyle.colors.surface),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppStyle.colors.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => const StudentBottomSheetNotifications(),
                  );
                },
                icon: Icon(CupertinoIcons.bell, color: AppStyle.colors.surface),
              ),

              InkWell(
                onTap: () async {
                  final currentUser = await AccountManager.currentAccount();
                  final progress = await ProgressManager.getProgressById(
                    currentUser!.id,
                  );

                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => WeeklyStreakBottomSheet(
                      currentStreak: progress?.currentStreak ?? 1,
                      longestStreak: progress?.longestStreak ?? 1,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: FutureBuilder(
                    future: AccountManager.currentAccount(),
                    builder: (context, currentUserSnapshot) {
                      if (currentUserSnapshot.hasData) {
                        return FutureBuilder(
                          future: ProgressManager.getProgressById(
                            currentUserSnapshot.data!.id,
                          ),
                          builder: (context, userProgressSnapShot) {
                            if (userProgressSnapShot.hasData) {
                              return Row(
                                children: [
                                  Text(
                                    '${userProgressSnapShot.data!.currentStreak} ',
                                  ),
                                  Icon(
                                    Icons.local_fire_department,
                                    color: AppStyle.colors.orange,
                                  ),
                                ],
                              );
                            } else {
                              return Center();
                            }
                          },
                        );
                      } else {
                        return Center();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Student Tools'),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return _StudentToolsExplianBottomSheet();
                        },
                      );
                    },
                    icon: Icon(CupertinoIcons.exclamationmark_circle),
                  ),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 160, // or whatever height you want
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: studentTools.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            studentTools[index]['nav_to'],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.grey,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(studentTools[index]['name']),
                        Container(
                          width: 150,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(studentTools[index]['pic']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Competitons'),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return _CompetititonsExplianBottomSheet();
                        },
                      );
                    },
                    icon: Icon(CupertinoIcons.exclamationmark_circle),
                  ),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: competitions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => competitions[index]['nav_to'],
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.grey,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Text(competitions[index]['name']),

                        const SizedBox(height: 8),

                        Expanded(
                          child: Image.asset(
                            competitions[index]['pic'],
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentToolsExplianBottomSheet extends StatelessWidget {
  const _StudentToolsExplianBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              'Student Tools',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const Text(
              'The tools that help student through his/her educational journey progress.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CompetititonsExplianBottomSheet extends StatelessWidget {
  const _CompetititonsExplianBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              'Competitons',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const Text(
              'Compete with classmates in exciting educational competitions. Earn points, unlock achievements, and prove your knowledge while making learning more fun than ever!',
            ),
          ],
        ),
      ),
    );
  }
}
