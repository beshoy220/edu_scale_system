import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherQuizCard extends StatelessWidget {
  const TeacherQuizCard({super.key, required this.quiz, this.onTap});

  final TeacherQuizModel quiz;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final quizStartAt = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(quiz.quizStartAt);
    bool isThisQuizPast = quiz.dueDate.isAfter(DateTime.now());
    final Duration timer = quiz.dueDate.difference(quiz.quizStartAt);

    return InkWell(
      borderRadius: BorderRadius.circular(24),

      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppStyle.colors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(CupertinoIcons.doc_text, size: 30),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.quizName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${quiz.gradeName}"
                    "${quiz.classNickname != null ? " • ${quiz.classNickname}" : ""}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Timer: ${timer.inMinutes} Mins",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    quiz.quizStartAt.isAfter(DateTime.now())
                        ? 'Opens at: $quizStartAt'
                        : 'Openned at: $quizStartAt',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isThisQuizPast
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: quiz.publishStatus == "published"
                              ? AppStyle.colors.green
                              : AppStyle.colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          quiz.publishStatus.toUpperCase(),
                          style: TextStyle(
                            color: AppStyle.colors.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Center(),

                const SizedBox(height: 12),
                Text(
                  "${quiz.questionsCount}\nQuestions",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
