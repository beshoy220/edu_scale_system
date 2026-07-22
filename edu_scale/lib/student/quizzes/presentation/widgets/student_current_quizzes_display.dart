import 'dart:async';

import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_model.dart';
import 'package:edu_scale/student/quizzes/presentation/providers/student_quiz_provider.dart';
import 'package:edu_scale/student/quizzes/presentation/widgets/student_view_quiz_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentCurrentQuizzesDisplay extends StatefulWidget {
  const StudentCurrentQuizzesDisplay({super.key});

  @override
  State<StudentCurrentQuizzesDisplay> createState() =>
      _StudentCurrentQuizzesDisplayState();
}

class _StudentCurrentQuizzesDisplayState
    extends State<StudentCurrentQuizzesDisplay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentQuizzesProvider>().getCurrentQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentQuizzesProvider>();
    return Builder(
      builder: (context) {
        if (provider.isLoading) {
          return Align(
            alignment: AlignmentGeometry.topCenter,
            child: LinearProgressIndicator(),
          );
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
          return const Center(child: Text('No current quizzes'));
        }

        return ListView.builder(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: provider.quizzes.length,
          itemBuilder: (_, index) {
            final quiz = provider.quizzes[index];
            return StudentQuizCard(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppStyle.colors.surface,
                  builder: (context) => StudentViewQuizBottomSheet(quiz: quiz),
                );
              },
              quiz: quiz,
            );
          },
        );
      },
    );
  }
}

class StudentQuizCard extends StatefulWidget {
  const StudentQuizCard({super.key, required this.quiz, this.onTap});

  final StudentQuizModel quiz;
  final VoidCallback? onTap;

  @override
  State<StudentQuizCard> createState() => _StudentQuizCardState();
}

class _StudentQuizCardState extends State<StudentQuizCard> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) {
      return '00m';
    }

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h';
    }

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quiz;
    final quizDuration = quiz.dueDate.difference(quiz.quizStartAt);
    final now = DateTime.now();
    final isDone = quiz.submission != null;
    final isOpen =
        !isDone && now.isAfter(quiz.quizStartAt) && now.isBefore(quiz.dueDate);

    final startDate = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(quiz.quizStartAt.toLocal());

    String badgeText;
    Color badgeColor;

    if (isDone) {
      badgeText = 'DONE';
      badgeColor = AppStyle.colors.green;
    } else if (isOpen) {
      badgeText = 'OPENED';
      badgeColor = AppStyle.colors.orange;
    } else {
      badgeText = 'YET';
      badgeColor = AppStyle.colors.yellow;
    }

    Widget trailingInfo;

    if (isDone) {
      trailingInfo = Text(
        '${quiz.submission!.numberOfCorrectQuestions}/${quiz.submission!.totalNumberOfQuestions}\nScore',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      );
    } else if (isOpen) {
      trailingInfo = Text(
        '${formatDuration(quiz.dueDate.difference(now))}\nLeft',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      );
    } else {
      trailingInfo = Text(
        '${quiz.numberOfQuestions}\nQuestions',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
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
                      quiz.subjectName,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Teacher: ${quiz.teacherName}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Opens at: $startDate',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Timer: ${formatDuration(quizDuration)}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: AppStyle.colors.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  trailingInfo,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
