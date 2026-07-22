import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_grade_class_model.dart';
import 'package:edu_scale/teacher/quizzes/presentation/pages/teacher_quizzes_page.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Entry point widget — wires up the [TeacherQuizUploadProvider]
/// for this editing session and hands off to the actual view.
class TeacherAddQuizPage extends StatelessWidget {
  final String quizName;
  final TeacherQuizGradeClassModel selectedGradeClass;
  final DateTime quizStartAt;
  final DateTime dueDate;

  const TeacherAddQuizPage({
    super.key,
    required this.quizName,
    required this.selectedGradeClass,
    required this.quizStartAt,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherQuizUploadProvider(
        quizName: quizName,
        gradeId: selectedGradeClass.gradeId,
        classId: selectedGradeClass.classId,
        quizStartAt: quizStartAt,
        dueDate: dueDate,
      ),
      child: const _TeacherAddQuizView(),
    );
  }
}

class _TeacherAddQuizView extends StatelessWidget {
  const _TeacherAddQuizView();

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
        ),
      );
  }

  Future<void> _handleSave(BuildContext context) async {
    final provider = context.read<TeacherQuizUploadProvider>();
    final error = await provider.upload();

    if (!context.mounted) return;

    if (error != null) {
      _showSnack(context, error, AppStyle.colors.red);
      return;
    }

    _showSnack(context, 'Quiz saved successfully!', AppStyle.colors.green);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => TeacherQuizzesPage()),
    );

    final currentUser = await AccountManager.currentAccount();

    if (provider.classId == null) {
      PushNotificationsService.sendNotification.sendByTopic(
        'school-${currentUser?.schoolId}-grade-${provider.gradeId}-student',
        'Quizz',
        'A new quiz has been added! Click to view.',
      );
    } else {
      PushNotificationsService.sendNotification.sendByTopic(
        'school-${currentUser?.schoolId}-grade-${provider.gradeId}-class-${provider.classId}-student',
        'Quizz',
        'A new quiz has been added! Click to view.',
      );
    }
  }

  void _openQuestionList(BuildContext context) {
    // showModalBottomSheet inserts its route into the app's Navigator,
    // which sits above this widget in the tree — so the provider has to
    // be re-supplied explicitly via .value() inside the sheet's builder.
    final provider = context.read<TeacherQuizUploadProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyle.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: _QuestionListSheet(
            onSelected: () => Navigator.pop(sheetContext),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.colors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onOpenQuestionList: () => _openQuestionList(context)),
            const SizedBox(height: 8),
            const _QuestionTitleField(),
            const SizedBox(height: 28),
            const Expanded(child: _OptionsList()),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActions(onSave: () => _handleSave(context)),
    );
  }
}

// ------------------------------------------------------------
// Header — back button + "Q1 of N" jump-to-question chip
// ------------------------------------------------------------

class _Header extends StatelessWidget {
  final VoidCallback onOpenQuestionList;
  const _Header({required this.onOpenQuestionList});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherQuizUploadProvider>();

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 18),
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Quiz'),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: onOpenQuestionList,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE7DC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Q${provider.currentIndex + 1} of ${provider.questionCount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppStyle.colors.brown,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Question title (borderless text field)
// ------------------------------------------------------------

class _QuestionTitleField extends StatelessWidget {
  const _QuestionTitleField();

  @override
  Widget build(BuildContext context) {
    final question = context.watch<TeacherQuizUploadProvider>().currentQuestion;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        key: ValueKey(question),
        controller: question.titleController,
        maxLines: null,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppStyle.colors.brown,
          height: 1.25,
        ),
        decoration: InputDecoration(
          hintText: 'Question title here...?',
          fillColor: Colors.transparent,
          hintStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppStyle.colors.brown.withAlpha(100),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Options list for the current question
// ------------------------------------------------------------

class _OptionsList extends StatelessWidget {
  const _OptionsList();

  void _showLimitSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppStyle.colors.black.withAlpha(200),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final question = context.watch<TeacherQuizUploadProvider>().currentQuestion;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        for (int i = 0; i < question.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _OptionPill(
              key: ValueKey(question.options[i]),
              controller: question.options[i].controller,
              isCorrect: question.correctIndex == i,
              onTapCircle: () =>
                  context.read<TeacherQuizUploadProvider>().setCorrectOption(i),
              onDelete: () =>
                  context.read<TeacherQuizUploadProvider>().removeOption(i),
            ),
          ),
        if (question.options.length < TeacherQuizUploadProvider.maxOptions)
          _AddOptionPill(
            onTap: () {
              final error = context
                  .read<TeacherQuizUploadProvider>()
                  .addOption();
              if (error != null) _showLimitSnack(context, error);
            },
          ),
      ],
    );
  }
}

/// A single answer option: plain text field inside a pill, with a
/// circle on the right the teacher taps to mark it as the correct
/// answer. Swipe left to remove the option.
class _OptionPill extends StatelessWidget {
  final TextEditingController controller;
  final bool isCorrect;
  final VoidCallback onTapCircle;
  final VoidCallback onDelete;

  const _OptionPill({
    super.key,
    required this.controller,
    required this.isCorrect,
    required this.onTapCircle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Dismissible(
        key: key!,
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(Icons.delete, color: AppStyle.colors.surface),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isCorrect ? AppStyle.colors.green : AppStyle.colors.grey,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isCorrect
                        ? AppStyle.colors.black
                        : AppStyle.colors.brown,
                  ),
                  decoration: InputDecoration(
                    fillColor: isCorrect
                        ? AppStyle.colors.green
                        : AppStyle.colors.grey,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: 'Answer',
                    hintStyle: TextStyle(
                      color: isCorrect
                          ? Colors.black
                          : AppStyle.colors.black.withAlpha(100),
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTapCircle,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCorrect ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isCorrect ? Colors.white : AppStyle.colors.brown,
                      width: 2,
                    ),
                  ),
                  child: isCorrect
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppStyle.colors.brown,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "+ Add option" pill shown when fewer than the max options exist.
class _AddOptionPill extends StatelessWidget {
  final VoidCallback onTap;
  const _AddOptionPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppStyle.colors.grey.withAlpha(150),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add option',
                style: TextStyle(
                  color: AppStyle.colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.add, color: AppStyle.colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Bottom action bar — Back / Add question / Save
// ------------------------------------------------------------

class _BottomActions extends StatelessWidget {
  final VoidCallback onSave;
  const _BottomActions({required this.onSave});

  void _showLimitSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppStyle.colors.black.withAlpha(200),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherQuizUploadProvider>();

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: provider.canGoBack
                    ? () => context.read<TeacherQuizUploadProvider>().goBack()
                    : null,
                child: const Row(
                  children: [Icon(Icons.arrow_back), Text('Back')],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final error = context
                      .read<TeacherQuizUploadProvider>()
                      .addQuestion();
                  if (error != null) _showLimitSnack(context, error);
                },
                child: const Row(children: [Icon(Icons.add), Text('Add Q')]),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: provider.isUploading ? null : onSave,
                child: provider.isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(children: [Icon(Icons.check), Text('Save')]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Question list bottom sheet (jump / delete)
// ------------------------------------------------------------

class _QuestionListSheet extends StatelessWidget {
  final VoidCallback onSelected;
  const _QuestionListSheet({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherQuizUploadProvider>();
    final questions = provider.questions;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppStyle.colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Jump to question',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppStyle.colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final preview = question.titleController.text.trim().isEmpty
                        ? '(empty question)'
                        : question.titleController.text.trim();
                    final isActive = index == provider.currentIndex;

                    return Material(
                      color: isActive
                          ? AppStyle.colors.brown
                          : AppStyle.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context
                              .read<TeacherQuizUploadProvider>()
                              .goToQuestion(index);
                          onSelected();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: isActive
                                    ? Colors.white24
                                    : AppStyle.colors.surface,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isActive
                                        ? Colors.white
                                        : AppStyle.colors.brown,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  preview,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : AppStyle.colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: isActive
                                      ? Colors.white70
                                      : AppStyle.colors.grey,
                                ),
                                onPressed: questions.length == 1
                                    ? null
                                    : () => context
                                          .read<TeacherQuizUploadProvider>()
                                          .deleteQuestion(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
