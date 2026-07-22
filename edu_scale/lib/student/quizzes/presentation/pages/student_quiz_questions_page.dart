import 'dart:async';

import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/progress_manager/progress_screens/gain_points_reward_page.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_questions_model.dart';
import 'package:edu_scale/student/quizzes/presentation/pages/student_quizzes_page.dart';
import 'package:edu_scale/student/quizzes/presentation/providers/student_quiz_questions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StudentQuizQuestionsPage extends StatefulWidget {
  final int quizId;
  final int durationMinutes;

  const StudentQuizQuestionsPage({
    super.key,
    required this.quizId,
    required this.durationMinutes,
  });

  @override
  State<StudentQuizQuestionsPage> createState() =>
      _StudentQuizQuestionsPageState();
}

class _StudentQuizQuestionsPageState extends State<StudentQuizQuestionsPage>
    with WidgetsBindingObserver {
  int currentQuestionIndex = 0;
  final Map<int, String> selectedAnswers = {};

  // ---- Timer state ----
  Timer? _quizTimer;
  late int _remainingSeconds;
  bool _timeIsUp = false;

  // ---- Exit-blocking / lifecycle state ----
  bool _quizCompleted = false; // becomes true right before we actually pop
  bool _isObscured = false; // true while app is backgrounded

  // ---- Screenshot protection (Android FLAG_SECURE via platform channel) ----
  static const _secureChannel = MethodChannel('app.secure_screen');

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentQuizQuestionsProvider>().getQuizQuestions(
        quizId: widget.quizId,
      );
    });

    _enableScreenshotProtection();
    _startTimer();
  }

  @override
  void dispose() {
    _quizTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _disableScreenshotProtection();
    super.dispose();
  }

  // Detects backgrounding (app switcher, incoming call, etc). Can't block
  // it, but we blur the content so it isn't visible in the OS app-switcher
  // thumbnail or during a screen recording started from outside the app.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted || _quizCompleted) return;
    setState(() {
      _isObscured = state != AppLifecycleState.resumed;
    });
  }

  Future<void> _enableScreenshotProtection() async {
    try {
      await _secureChannel.invokeMethod('secure_on');
    } catch (_) {
      // No-op on platforms/builds where the native side isn't wired up yet.
    }
  }

  Future<void> _disableScreenshotProtection() async {
    try {
      await _secureChannel.invokeMethod('secure_off');
    } catch (_) {}
  }

  void _startTimer() {
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _timeIsUp = true;
        _autoSubmitOnTimeout();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _timeIsLow => _remainingSeconds <= 60;

  Future<void> _autoSubmitOnTimeout() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Time\'s up — submitting your answers')),
    );
    await _submitQuiz();
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

  void _showQuestionsList(List<StudentQuizQuestionsModel> questions) {
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
                const Text(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          question.questionText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Future<bool> _confirmExit() async {
    if (_quizCompleted) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave quiz?'),
          content: const Text(
            'Your progress will be lost and this attempt may be recorded as '
            'incomplete. Are you sure you want to leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
    return leave ?? false;
  }

  Future<void> _showSubmitConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Quiz'),
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
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, Submit'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _submitQuiz();
    }
  }

  Future<void> _submitQuiz() async {
    _quizTimer?.cancel();

    final success = await context
        .read<StudentQuizQuestionsProvider>()
        .submitStudentAnswers(
          quizId: widget.quizId,
          selectedAnswers: selectedAnswers,
        );

    if (!mounted) return;
    context.read<StudentQuizQuestionsProvider>().clearquizQuestions();

    if (success) {
      _quizCompleted = true; // allow PopScope to let us leave now
      // Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => StudentQuizzesPage(),
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
        'Quiz',
        'Your child has just finished a quiz! Click to view.',
      );
    } else {
      final errorMessage = context
          .read<StudentQuizQuestionsProvider>()
          .errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Failed to submit quiz')),
      );
      // Timer stays cancelled after a failed submit if time was already up;
      // otherwise restart it so the student can retry within the remaining time.
      if (!_timeIsUp) _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentQuizQuestionsProvider>();

    return PopScope(
      canPop: _quizCompleted,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmExit();
        if (shouldLeave && mounted) {
          _quizCompleted = true; // treat an explicit leave like completion
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Builder(
                builder: (context) {
                  if (provider.isLoading && provider.quizQuestions.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null &&
                      provider.quizQuestions.isEmpty) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }

                  if (provider.quizQuestions.isEmpty) {
                    return Center(
                      child: Text(
                        'No questions found',
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }

                  final currentQuestion =
                      provider.quizQuestions[currentQuestionIndex];
                  final isLastQuestion =
                      currentQuestionIndex == provider.quizQuestions.length - 1;
                  final selectedAnswer = selectedAnswers[currentQuestion.id];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final shouldLeave = await _confirmExit();
                                if (shouldLeave && mounted) {
                                  _quizCompleted = true;
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Quiz',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // ---- Timer pill ----
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _timeIsLow
                                    ? AppStyle.colors.red
                                    : AppStyle.colors.brown,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: AppStyle.colors.surface,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formattedTime,
                                    style: TextStyle(
                                      color: AppStyle.colors.surface,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ---- Question counter pill ----
                            InkWell(
                              onTap: () =>
                                  _showQuestionsList(provider.quizQuestions),
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
                                  '${currentQuestionIndex + 1} of ${provider.quizQuestions.length}',
                                  style: TextStyle(
                                    color: AppStyle.colors.surface,
                                  ),
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
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
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
                                    border: Border.all(
                                      color: isSelected
                                          ? AppStyle.colors.black
                                          : Colors.transparent,
                                    ),
                                  ),

                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
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
                                  padding: const EdgeInsets.all(18),
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
                                  style: TextStyle(
                                    color: AppStyle.colors.black,
                                  ),
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
                                            provider.quizQuestions.length,
                                          );
                                        }
                                      },
                                icon: Icon(
                                  isLastQuestion
                                      ? Icons.check
                                      : Icons.arrow_forward,
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
              // ---- Obscuring overlay while app is backgrounded ----
              if (_isObscured)
                Positioned.fill(
                  child: Container(
                    color: AppStyle.colors.surface,
                    child: const Center(
                      child: Icon(Icons.visibility_off_outlined, size: 40),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
