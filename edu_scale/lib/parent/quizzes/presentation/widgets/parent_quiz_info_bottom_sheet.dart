import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class ParentQuizInfoBottomSheet extends StatelessWidget {
  const ParentQuizInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                        const Text(
                          'Past Quizzes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                            text:
                                'Quizzes that have passed their due date are displayed here.\n\nEach quiz is marked as ',
                          ),
                          TextSpan(
                            text: 'Done',
                            style: TextStyle(
                              color: AppStyle.colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' or '),
                          TextSpan(
                            text: 'Missed',
                            style: TextStyle(
                              color: AppStyle.colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' depending on whether your child completed it before the deadline.\n\nIf the quiz has been done, your child\'s score will also be shown.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      children: [
                        const Text(
                          'Quizzes score',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      'Simply Score shows how many questions your child answered correctly out of the total number of questions.\n\nNote: Scores are calculated automatically by comparing your child\'s answers with the teacher\'s answer key.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
