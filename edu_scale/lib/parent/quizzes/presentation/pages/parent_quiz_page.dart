import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/quizzes/presentation/providers/parent_past_quizzes_provider.dart';
import 'package:edu_scale/parent/quizzes/presentation/widgets/parent_quiz_info_bottom_sheet.dart';
import 'package:edu_scale/parent/quizzes/presentation/widgets/parent_past_quiz_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentQuizPage extends StatefulWidget {
  const ParentQuizPage({super.key});

  @override
  State<ParentQuizPage> createState() => _ParentQuizPageState();
}

class _ParentQuizPageState extends State<ParentQuizPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentPastQuizzesProvider>().getPastQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParentPastQuizzesProvider>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
              decoration: BoxDecoration(
                color: AppStyle.colors.brown,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                image: const DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/pics/shape_3.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppStyle.colors.surface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Past Quizzes',
                        style: AppStyle.theme.primaryTextTheme.bodyLarge
                            ?.copyWith(
                              color: AppStyle.colors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppStyle.colors.surface,
                            builder: (_) => const ParentQuizInfoBottomSheet(),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: AppStyle.colors.surface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: LinearProgressIndicator(),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }

                  if (provider.pastQuizzesList.isEmpty) {
                    return const Center(child: Text('No past quizzes found.'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.pastQuizzesList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final quiz = provider.pastQuizzesList[index];

                      return ParentPastQuizCard(quiz: quiz);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
