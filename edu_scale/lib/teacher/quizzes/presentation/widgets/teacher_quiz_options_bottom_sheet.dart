import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/presentation/pages/teacher_quiz_insights_page.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherQuizOptionsBottomSheet extends StatelessWidget {
  final int quizIndex;

  const TeacherQuizOptionsBottomSheet({super.key, required this.quizIndex});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<TeacherQuizzesProvider>().quizzes[quizIndex];

    bool isThisQuizPast = quiz.dueDate.isAfter(DateTime.now());

    return SafeArea(
      child: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),

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

              const SizedBox(height: 16),

              const Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold)),

              Text(quiz.quizName),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppStyle.colors.green, // Button color
                          foregroundColor:
                              AppStyle.colors.surface, // Text color
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  TeacherQuizInsightsPage(quizId: quiz.quizId),
                            ),
                          );
                        },
                        child: const Text('View insights'),
                      ),
                    ),

                    isThisQuizPast
                        ? SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    quiz.publishStatus == 'published'
                                    ? AppStyle.colors.red
                                    : AppStyle.colors.green, // Button color
                                foregroundColor:
                                    AppStyle.colors.surface, // Text color
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                if (quiz.publishStatus == 'published') {
                                  context
                                      .read<TeacherQuizzesProvider>()
                                      .updatePublishState(
                                        quizId: quiz.quizId,
                                        newPublishState: 'unpublished',
                                      );
                                } else {
                                  context
                                      .read<TeacherQuizzesProvider>()
                                      .updatePublishState(
                                        quizId: quiz.quizId,
                                        newPublishState: 'published',
                                      );
                                }
                              },
                              child: Text(
                                quiz.publishStatus == 'published'
                                    ? 'Unpublish from studdents'
                                    : 'Publish to students',
                              ),
                            ),
                          )
                        : Center(),

                    isThisQuizPast
                        ? Center()
                        : SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppStyle.colors.black
                                    .withAlpha(40), // Button color
                                foregroundColor:
                                    AppStyle.colors.surface, // Text color
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {},
                              child: Text('Republish (Under development)'),
                            ),
                          ),

                    // isThisQuizPast
                    //     ? SizedBox(
                    //         width: double.maxFinite,
                    //         child: ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //             elevation: 0,
                    //             backgroundColor: AppStyle.colors.black
                    //                 .withAlpha(40), // Button color
                    //             foregroundColor:
                    //                 AppStyle.colors.surface, // Text color
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: 24,
                    //               vertical: 12,
                    //             ),
                    //           ),
                    //           onPressed: () {},
                    //           child: const Text(
                    //             'Edit Quiz (Under development)',
                    //           ),
                    //         ),
                    //       )
                    //     : Center(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
