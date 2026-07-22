import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/progress_manager/progress_screens/gain_points_reward_page.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_questions_model.dart';
import 'package:edu_scale/student/assignments/presentation/pages/student_assignments_page.dart';
import 'package:edu_scale/student/assignments/presentation/providers/student_assignment_questions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentAssignmentQuestionsPage extends StatefulWidget {
  final int assignmentId;

  const StudentAssignmentQuestionsPage({super.key, required this.assignmentId});

  @override
  State<StudentAssignmentQuestionsPage> createState() =>
      _StudentAssignmentQuestionsPageState();
}

class _StudentAssignmentQuestionsPageState
    extends State<StudentAssignmentQuestionsPage> {
  int currentQuestionIndex = 0;
  final Map<int, String> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAssignmentQuestionsProvider>().getAssignmentQuestions(
        assignmentId: widget.assignmentId,
      );
    });
  }

  void _selectAnswer(int questionId, String option) {
    setState(() {
      selectedAnswers[questionId] = option;
    });
  }

  void _goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _goToNextQuestion(int totalQuestions) {
    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _showQuestionsList(List<StudentAssignmentQuestionsModel> questions) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyle.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Questions No.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return ListTile(
                        title: Text(
                          'Question ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          question.questionText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          setState(() {
                            currentQuestionIndex = index;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSubmitConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Assignment'),
          content: const Text(
            'Once submitted, your answers can not be changed. '
            'Are you sure you want to submit?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _submitAssignment,
              child: const Text('Yes, Submit'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _submitAssignment();
    }
  }

  Future<void> _submitAssignment() async {
    final success = await context
        .read<StudentAssignmentQuestionsProvider>()
        .submitStudentAnswers(
          assignmentId: widget.assignmentId,
          selectedAnswers: selectedAnswers,
        );

    if (!mounted) return;
    context
        .read<StudentAssignmentQuestionsProvider>()
        .clearassignmentQuestions();

    if (success) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => StudentAssignmentsPage(),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => GainPointsRewardPage(points: 10),
        ),
      );

      final currentUser = await AccountManager.currentAccount();

      PushNotificationsService.sendNotification.sendByUserId(
        currentUser!.ids.parentId!,
        'Assignment',
        'Your child has just finished an assignment! Click to view.',
      );
    } else {
      final errorMessage = context
          .read<StudentAssignmentQuestionsProvider>()
          .errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Failed to submit assignment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentAssignmentQuestionsProvider>();

    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) {
            if (provider.isLoading && provider.assignmentQuestions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null &&
                provider.assignmentQuestions.isEmpty) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: AppStyle.colors.red),
                ),
              );
            }

            if (provider.assignmentQuestions.isEmpty) {
              return Center(
                child: Text(
                  'No questions found',
                  style: TextStyle(color: AppStyle.colors.red),
                ),
              );
            }

            final currentQuestion =
                provider.assignmentQuestions[currentQuestionIndex];
            final isLastQuestion =
                currentQuestionIndex == provider.assignmentQuestions.length - 1;
            final selectedAnswer = selectedAnswers[currentQuestion.id];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Assignment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          // color: AppStyle.colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () =>
                            _showQuestionsList(provider.assignmentQuestions),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.brown,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '${currentQuestionIndex + 1} of ${provider.assignmentQuestions.length}',
                            style: TextStyle(color: AppStyle.colors.surface),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentQuestion.questionText,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        // color: AppStyle.colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      final isSelected = selectedAnswer == option;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () =>
                              _selectAnswer(currentQuestion.id, option),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // color: AppStyle.colors.textPrimary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  // color: AppStyle.colors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(18),
                          ),
                          onPressed: currentQuestionIndex == 0
                              ? null
                              : _goToPreviousQuestion,
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppStyle.colors.black,
                          ),
                          label: Text(
                            'Back',
                            style: TextStyle(color: AppStyle.colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLastQuestion
                                ? AppStyle.colors.green
                                : AppStyle.colors.brown,
                          ),
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  if (isLastQuestion) {
                                    _showSubmitConfirmationDialog();
                                  } else {
                                    _goToNextQuestion(
                                      provider.assignmentQuestions.length,
                                    );
                                  }
                                },
                          icon: Icon(
                            isLastQuestion ? Icons.check : Icons.arrow_forward,
                          ),
                          label: Text(isLastQuestion ? 'Submit' : 'Next'),
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
