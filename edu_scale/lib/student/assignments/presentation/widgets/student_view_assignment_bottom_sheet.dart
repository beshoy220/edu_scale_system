import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_model.dart';
import 'package:edu_scale/student/assignments/presentation/pages/student_assignment_questions_page.dart';
import 'package:flutter/material.dart';

class StudentViewAssignmentBottomSheet extends StatelessWidget {
  final StudentAssignmentModel assignment;

  const StudentViewAssignmentBottomSheet({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    bool isCurrentAssignment = assignment.dueDate.isAfter(DateTime.now());
    bool isDone = assignment.submission != null;

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

                  Text(
                    'Assignment',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(assignment.topic),

                  const SizedBox(height: 20),

                  if (isCurrentAssignment && isDone)
                    Text(
                      'You have successfully submitted this assignment with ${(assignment.submission!.numberOfCorrectQuestions / assignment.submission!.totalNumberOfQuestions * 100).roundToDouble()}% score percentage',
                    ),

                  if (isCurrentAssignment && !isDone)
                    Column(
                      children: [
                        Text(
                          'It seems that this assignment is not submitted, if you are ready let\'s start the assignment!',
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      StudentAssignmentQuestionsPage(
                                        assignmentId: assignment.id,
                                      ),
                                ),
                              );
                            },
                            child: Text('Let\'s start the assignment'),
                          ),
                        ),
                      ],
                    ),

                  if (!isCurrentAssignment && isDone)
                    Text(
                      'You have successfully submitted this assignment with ${(assignment.submission!.numberOfCorrectQuestions / assignment.submission!.totalNumberOfQuestions * 100).roundToDouble()}% score percentage',
                    ),

                  if (!isCurrentAssignment && !isDone)
                    Text(
                      'It seems that you have missed this assignment, skipping much assignments is not a good practice!',
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
