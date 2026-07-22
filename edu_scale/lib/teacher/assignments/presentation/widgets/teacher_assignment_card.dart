import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({
    super.key,
    required this.assignment,
    this.onTap,
  });

  final TeacherAssignmentModel assignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dueDate = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(assignment.dueDate);

    bool isThisAssignmentPast = assignment.dueDate.isAfter(DateTime.now());

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
                    assignment.assignmentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${assignment.gradeName}"
                    "${assignment.classNickname != null ? " • ${assignment.classNickname}" : ""}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Due: $dueDate",
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
                isThisAssignmentPast
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: assignment.publishStatus == "published"
                              ? AppStyle.colors.green
                              : AppStyle.colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          assignment.publishStatus.toUpperCase(),
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
                  "${assignment.questionsCount}\nQuestions",
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
