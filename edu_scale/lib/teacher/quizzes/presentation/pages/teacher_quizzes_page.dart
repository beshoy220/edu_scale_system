import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_provider.dart';
import 'package:edu_scale/teacher/quizzes/presentation/widgets/teacher_quiz_add_bottom_sheet.dart';
import 'package:edu_scale/teacher/quizzes/presentation/widgets/teacher_quiz_card.dart';
import 'package:edu_scale/teacher/quizzes/presentation/widgets/teacher_quiz_info_bottom_sheet.dart';
import 'package:edu_scale/teacher/quizzes/presentation/widgets/teacher_quiz_options_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherQuizzesPage extends StatefulWidget {
  const TeacherQuizzesPage({super.key});

  @override
  State<TeacherQuizzesPage> createState() => _TeacherQuizzesPageState();
}

class _TeacherQuizzesPageState extends State<TeacherQuizzesPage> {
  bool showCurrentQuiz = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherQuizzesProvider>().getCurrentQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherQuizzesProvider>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),

              decoration: BoxDecoration(
                color: AppStyle.colors.brown,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),

                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/pics/shape_3.png'),
                  fit: BoxFit.contain,
                ),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppStyle.colors.surface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Quizzes',
                        style: AppStyle.theme.primaryTextTheme.bodyLarge
                            ?.copyWith(
                              color: AppStyle.colors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppStyle.colors.surface,
                            builder: (context) => TeacherQuizInfoBottomSheet(),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: AppStyle.colors.surface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.onBrown,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuizTab(
                            title: 'Current Quizzes',
                            selected: showCurrentQuiz,
                            onTap: () {
                              setState(() {
                                showCurrentQuiz = true;
                                provider.clearQuizzes();
                                provider.getCurrentQuizzes();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _QuizTab(
                            title: 'Past Quizzes',
                            selected: !showCurrentQuiz,
                            onTap: () {
                              setState(() {
                                showCurrentQuiz = false;
                                provider.clearQuizzes();
                                provider.getLast150PastQuizzes();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(color: AppStyle.colors.red),
                    ),
                  );
                }

                if (provider.quizzes.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        Icon(CupertinoIcons.doc),
                        SizedBox(height: 4),
                        Text('No quizzes found'),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.quizzes.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final quiz = provider.quizzes[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TeacherQuizCard(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: AppStyle.colors.surface,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (_) => TeacherQuizOptionsBottomSheet(
                                  quizIndex: index,
                                ),
                              );
                            },
                            quiz: quiz,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: AppStyle.colors.brown,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppStyle.colors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => TeacherQuizAddBottomSheet(),
            );
          },
          label: Row(
            children: [
              Icon(CupertinoIcons.add, color: AppStyle.colors.surface),
              const SizedBox(width: 12),
              Text(
                'Add Quiz',
                style: TextStyle(color: AppStyle.colors.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _QuizTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppStyle.colors.brown : AppStyle.colors.onBrown,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: Text(title, style: TextStyle(color: AppStyle.colors.surface)),
        ),
      ),
    );
  }
}
