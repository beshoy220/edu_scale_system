import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentInfoBottomSheet extends StatelessWidget {
  const TeacherAssignmentInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(CupertinoIcons.clock_fill),
                      SizedBox(width: 4),
                      const Text(
                        'Current Assignments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Assignments whose due date has not passed yet. Students can still view and submit their work before the deadline.',
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(CupertinoIcons.clock),
                      SizedBox(width: 4),
                      const Text(
                        'Past Assignments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Assignments whose due date has already passed. They are kept for reference and review.',
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(CupertinoIcons.eye_fill),
                      SizedBox(width: 4),
                      const Text(
                        'Published Assignments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Assignments that are visible to students. Students can access the assignment.',
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(CupertinoIcons.eye_slash_fill),
                      SizedBox(width: 4),
                      const Text(
                        'Unpublished Assignments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Assignments that are hidden from students. They cannot view or interact with these assignments until they are published.',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
