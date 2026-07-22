import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_model_answer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherQuizModelAnswerPage extends StatefulWidget {
  final int quizId;

  const TeacherQuizModelAnswerPage({super.key, required this.quizId});

  @override
  State<TeacherQuizModelAnswerPage> createState() =>
      _TeacherQuizModelAnswerPageState();
}

class _TeacherQuizModelAnswerPageState
    extends State<TeacherQuizModelAnswerPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherQuizModelAnswerProvider>().getQuestions(
        quizId: widget.quizId,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    context.read<TeacherQuizModelAnswerProvider>().clearQuestions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherQuizModelAnswerProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Model Answers'),
              Text(
                'Review each question and its answer',
                style: AppStyle.theme.primaryTextTheme.bodyMedium,
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            if (provider.questions.isEmpty) {
              return const Center(child: Text('No questions found.'));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Question ${_currentPage + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Text(
                        '${_currentPage + 1}/${provider.questions.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / provider.questions.length,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: provider.questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final question = provider.questions[index];

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.grey,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.questionText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                ...question.options.map(
                                  (option) => Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: option == question.modelAnswer
                                          ? AppStyle.colors.green.withAlpha(40)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: option == question.modelAnswer
                                            ? AppStyle.colors.green
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  option == question.modelAnswer
                                                  ? AppStyle.colors.green
                                                  : null,
                                              fontWeight:
                                                  option == question.modelAnswer
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (option == question.modelAnswer)
                                          Icon(
                                            Icons.check_circle,
                                            color: AppStyle.colors.green,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                const Divider(),

                                const SizedBox(height: 16),

                                const Text(
                                  'Model Answer',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  question.modelAnswer,
                                  style: TextStyle(
                                    color: AppStyle.colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentPage == 0
                              ? null
                              : () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed:
                              _currentPage == provider.questions.length - 1
                              ? null
                              : () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
