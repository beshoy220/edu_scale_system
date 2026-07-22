import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/presentation/pages/teacher_assignment_model_answer_page.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_student_submissions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherAssignmentInsightsPage extends StatefulWidget {
  final int assignmentId;

  const TeacherAssignmentInsightsPage({super.key, required this.assignmentId});

  @override
  State<TeacherAssignmentInsightsPage> createState() =>
      _TeacherAssignmentInsightsPageState();
}

class _TeacherAssignmentInsightsPageState
    extends State<TeacherAssignmentInsightsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TeacherAssignmentStudentSubmissionsProvider>()
          .getStudentSubmissions(assignmentId: widget.assignmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context
        .watch<TeacherAssignmentStudentSubmissionsProvider>();

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
              const Text('Insights'),
              Text(
                "Assignment's insights",
                style: AppStyle.theme.primaryTextTheme.bodyMedium,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Builder(
                builder: (_) {
                  if (provider.isLoading) {
                    return const Center(child: LinearProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }

                  if (provider.studentSubmissions.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 200),
                          Text('No submissions yet.'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.studentSubmissions.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final submission = provider.studentSubmissions[index];

                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.grey,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            title: Text(submission.studentName),
                            subtitle: Text(
                              '${submission.numberOfCorrectQuestions}/${submission.totalNumberOfQuestions} correct',
                            ),
                            trailing: Text(
                              '${((submission.numberOfCorrectQuestions / submission.totalNumberOfQuestions) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(8, 0, 8, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        TeacherAssignmentModelAnswerPage(
                          assignmentId: widget.assignmentId,
                        ),
                  ),
                );
              },
              child: const Text('View Model Answer'),
            ),
          ),
        ),
      ),
    );
  }
}
