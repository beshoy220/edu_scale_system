import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/quizzes/data/models/parent_past_quiz_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParentPastQuizCard extends StatelessWidget {
  const ParentPastQuizCard({super.key, required this.quiz, this.onTap});

  final ParentPastQuizModel quiz;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final submitted = quiz.isSubmitted;
    final submission = quiz.submission;

    final quizStartAt = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(quiz.quizStartAt.toLocal());

    final duration = quiz.dueDate.difference(quiz.quizStartAt);

    String durationText;

    if (duration.inDays > 0) {
      durationText = '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      durationText =
          '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      durationText = '${duration.inMinutes} min';
    }
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
            /// Quiz Icon
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppStyle.colors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                CupertinoIcons.doc_text,
                color: submitted ? AppStyle.colors.green : AppStyle.colors.red,
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            /// Quiz Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Subject: ${quiz.subject.name}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Teacher: ${quiz.teacher.name}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),
                  Text(
                    'Start at: $quizStartAt',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Timer: $durationText',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// Right Side
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: submitted
                        ? AppStyle.colors.green
                        : AppStyle.colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    submitted ? "DONE" : "MISSED",
                    style: TextStyle(
                      color: AppStyle.colors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                submitted
                    ? Text(
                        "${submission!.numberOfCorrectQuestions}/${submission.totalNumberOfQuestions}\nScore",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      )
                    : Text(
                        "${quiz.numberOfQuestions}\nQuestions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
