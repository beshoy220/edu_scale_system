import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/presentation/pages/teacher_assignment_insights_page.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherAssignmentOptionsBottomSheet extends StatelessWidget {
  final int assignmentIndex;

  const TeacherAssignmentOptionsBottomSheet({
    super.key,
    required this.assignmentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final assignment = context
        .watch<TeacherAssignmentsProvider>()
        .assignments[assignmentIndex];

    bool isThisAssignmentPast = assignment.dueDate.isAfter(DateTime.now());

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

              const Text(
                'Assignment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(assignment.assignmentName),

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
                                  TeacherAssignmentInsightsPage(
                                    assignmentId: assignment.assignmentId,
                                  ),
                            ),
                          );
                        },
                        child: const Text('View insights'),
                      ),
                    ),

                    isThisAssignmentPast
                        ? SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    assignment.publishStatus == 'published'
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
                                if (assignment.publishStatus == 'published') {
                                  context
                                      .read<TeacherAssignmentsProvider>()
                                      .updatePublishState(
                                        assignmentId: assignment.assignmentId,
                                        newPublishState: 'unpublished',
                                      );
                                } else {
                                  context
                                      .read<TeacherAssignmentsProvider>()
                                      .updatePublishState(
                                        assignmentId: assignment.assignmentId,
                                        newPublishState: 'published',
                                      );
                                }
                              },
                              child: Text(
                                assignment.publishStatus == 'published'
                                    ? 'Unpublish from studdents'
                                    : 'Publish to students',
                              ),
                            ),
                          )
                        : Center(),

                    isThisAssignmentPast
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

                    // isThisAssignmentPast
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
                    //             'Edit assignment (Under development)',
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
