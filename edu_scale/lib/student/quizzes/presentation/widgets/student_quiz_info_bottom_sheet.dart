import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentQuizInfoBottomSheet extends StatelessWidget {
  const StudentQuizInfoBottomSheet({super.key});

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
                        'Current Quizzes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Quizzes whose due date has not passed yet. Students can still view and submit their work before the deadline.',
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(CupertinoIcons.clock),
                      SizedBox(width: 4),
                      const Text(
                        'Past Quizzes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Text(
                    'Quizzes whose due date has already passed. They are kept for reference and review.',
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
