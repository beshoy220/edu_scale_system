import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_model.dart';
import 'package:edu_scale/student/assignments/presentation/providers/student_assignment_provider.dart';
import 'package:edu_scale/student/assignments/presentation/widgets/student_view_assignment_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentCurrentAssignmentsDisplay extends StatefulWidget {
  const StudentCurrentAssignmentsDisplay({super.key});

  @override
  State<StudentCurrentAssignmentsDisplay> createState() =>
      _StudentCurrentAssignmentsDisplayState();
}

class _StudentCurrentAssignmentsDisplayState
    extends State<StudentCurrentAssignmentsDisplay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAssignmentsProvider>().getCurrentAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentAssignmentsProvider>();
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

        if (provider.assignments.isEmpty) {
          return const Center(child: Text('No current assignments'));
        }

        return ListView.builder(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: provider.assignments.length,
          itemBuilder: (_, index) {
            final assignment = provider.assignments[index];
            return StudentAssignmentCard(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppStyle.colors.surface,
                  builder: (context) =>
                      StudentViewAssignmentBottomSheet(assignment: assignment),
                );
              },
              assignment: assignment,
            );
          },
        );
      },
    );
  }
}

class StudentAssignmentCard extends StatelessWidget {
  const StudentAssignmentCard({
    super.key,
    required this.assignment,
    this.onTap,
  });

  final StudentAssignmentModel assignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final submitted = assignment.submission != null;

    final dueDate = DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(assignment.dueDate.toLocal());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
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
                      assignment.topic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      assignment.subjectName,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Teacher: ${assignment.teacherName}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Due: $dueDate',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: submitted
                          ? AppStyle.colors.green
                          : AppStyle.colors.yellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      submitted ? 'DONE' : 'YET',
                      style: TextStyle(
                        color: AppStyle.colors.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    assignment.submission != null
                        ? '${assignment.submission!.numberOfCorrectQuestions}/${assignment.submission!.totalNumberOfQuestions}\nScore'
                        : '${assignment.numberOfQuestions}\nQuestions',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
