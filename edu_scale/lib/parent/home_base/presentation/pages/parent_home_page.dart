import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/assignments/presentation/pages/parent_assignment_page.dart';
import 'package:edu_scale/parent/home_base/presentation/widgets/parent_bottom_sheet_notifications.dart';
import 'package:edu_scale/parent/home_base/presentation/widgets/parent_bottom_sheet_student_info.dart';
import 'package:edu_scale/parent/home_base/presentation/widgets/parent_tool_card.dart';
import 'package:edu_scale/parent/progress/presentation/pages/parent_progress_page.dart';
import 'package:edu_scale/parent/quizzes/presentation/pages/parent_quiz_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final currentUser = AccountManager.currentAccount();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await AccountManager.currentAccount();

      PushNotificationsService.init();
      PushNotificationsService.topics.subscribeToParentTopics(currentUser!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                                  'Good morning ${(snapshot.data!.gender == 'male') ? 'Mr.' : 'Mrs.'} ${snapshot.data!.displayName.split(' ')[0]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.colors.surface,
                                  ),
                                  maxLines: 1,
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
                            'Parent account',
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
                      builder: (_) => const ParentBottomSheetNotifications(),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.bell,
                    color: AppStyle.colors.surface,
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.person_2,
                          color: AppStyle.colors.surface,
                        ),
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
                            builder: (_) =>
                                const ParentBottomSheetStudentInfo(),
                          );
                        },
                      ),
                    ],
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
                  'Parent tools',
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
                                  'Parent Tools',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const Text(
                                  'The tools that help parent to see his/her children\'s progress.',
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

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 4, 8),
                  child: ParentToolCard(
                    title: 'Assignments',
                    subtitle: 'View my child\'s assignemnts',
                    icon: CupertinoIcons.doc_text,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ParentAssignmentPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
                  child: ParentToolCard(
                    title: 'Quizzes',
                    subtitle: 'View my child\'s quizzes',
                    icon: CupertinoIcons.doc,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ParentQuizPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParentProgressPage()),
              );
            },
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.fromLTRB(18, 4, 18, 8),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppStyle.colors.brown,
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  alignment: AlignmentGeometry.centerRight,
                  image: AssetImage('assets/pics/shape_5.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppStyle.colors.onBrown,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      CupertinoIcons.rocket,
                      size: 28,
                      color: AppStyle.colors.surface,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppStyle.colors.surface,
                        ),
                      ),

                      Text(
                        'View my child progress',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.theme.primaryTextTheme.bodySmall
                            ?.copyWith(color: AppStyle.colors.surface),
                      ),
                    ],
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
