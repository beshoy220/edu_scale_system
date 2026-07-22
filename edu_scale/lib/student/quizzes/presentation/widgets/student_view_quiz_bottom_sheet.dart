import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_model.dart';
import 'package:edu_scale/student/quizzes/presentation/pages/student_quiz_questions_page.dart';
import 'package:flutter/material.dart';

class StudentViewQuizBottomSheet extends StatelessWidget {
  final StudentQuizModel quiz;

  const StudentViewQuizBottomSheet({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentQuiz = quiz.dueDate.isAfter(now);
    final isDone = quiz.submission != null;

    final hasStarted = !now.isBefore(quiz.quizStartAt);
    final isOpen = isCurrentQuiz && hasStarted && !isDone;

    final isYet = isCurrentQuiz && !hasStarted && !isDone;
    final isMissed = !isCurrentQuiz && !isDone;

    final duration = quiz.dueDate.difference(quiz.quizStartAt);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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

            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold)),

                  Text(quiz.topic),

                  const SizedBox(height: 20),

                  if (isDone)
                    Text(
                      'You have successfully submitted this quiz with '
                      '${((quiz.submission!.numberOfCorrectQuestions / quiz.submission!.totalNumberOfQuestions) * 100).round()}% score.',
                    ),

                  if (isOpen)
                    Column(
                      children: [
                        const Text('The quiz is now open. Good luck!'),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudentQuizQuestionsPage(
                                    quizId: quiz.id,
                                    durationMinutes: duration.inMinutes,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Let's Start"),
                          ),
                        ),
                      ],
                    ),

                  if (isYet)
                    const Text(
                      'This quiz has not started yet. Please come back when it opens.',
                    ),

                  if (isMissed)
                    const Text(
                      'It seems that you missed this quiz. Try not to miss upcoming quizzes!',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
