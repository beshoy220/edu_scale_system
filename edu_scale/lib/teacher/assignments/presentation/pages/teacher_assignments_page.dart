import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_provider.dart';
import 'package:edu_scale/teacher/assignments/presentation/widgets/teacher_assignment_add_bottom_sheet.dart';
import 'package:edu_scale/teacher/assignments/presentation/widgets/teacher_assignment_card.dart';
import 'package:edu_scale/teacher/assignments/presentation/widgets/teacher_assignment_info_bottom_sheet.dart';
import 'package:edu_scale/teacher/assignments/presentation/widgets/teacher_assignment_options_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherAssignmentsPage extends StatefulWidget {
  const TeacherAssignmentsPage({super.key});

  @override
  State<TeacherAssignmentsPage> createState() => _TeacherAssignmentsPageState();
}

class _TeacherAssignmentsPageState extends State<TeacherAssignmentsPage> {
  bool showCurrentAssignment = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherAssignmentsProvider>().getCurrentAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherAssignmentsProvider>();

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

                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/pics/shape_3.png'),
                  fit: BoxFit.contain,
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
                        'Assignments',
                        style: AppStyle.theme.primaryTextTheme.bodyLarge
                            ?.copyWith(
                              color: AppStyle.colors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppStyle.colors.surface,
                            builder: (context) =>
                                TeacherAssignmentInfoBottomSheet(),
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.onBrown,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AssignmentTab(
                            title: 'Current Assignments',
                            selected: showCurrentAssignment,
                            onTap: () {
                              setState(() {
                                showCurrentAssignment = true;
                                provider.clearAssignments();
                                provider.getCurrentAssignments();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _AssignmentTab(
                            title: 'Past Assignments',
                            selected: !showCurrentAssignment,
                            onTap: () {
                              setState(() {
                                showCurrentAssignment = false;
                                provider.clearAssignments();
                                provider.getLast150PastAssignments();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return LinearProgressIndicator();
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(color: AppStyle.colors.red),
                    ),
                  );
                }

                if (provider.assignments.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        Icon(CupertinoIcons.doc_text),
                        SizedBox(height: 4),
                        Text('No assignments found'),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.assignments.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final assignment = provider.assignments[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TeacherAssignmentCard(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: AppStyle.colors.surface,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (_) =>
                                    TeacherAssignmentOptionsBottomSheet(
                                      assignmentIndex: index,
                                    ),
                              );
                            },
                            assignment: assignment,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppStyle.colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppStyle.colors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => TeacherAssignmentAddBottomSheet(),
            );
          },
          label: Row(
            children: [
              Icon(CupertinoIcons.add, color: AppStyle.colors.surface),
              const SizedBox(width: 12),
              Text(
                'Add Assignment',
                style: TextStyle(color: AppStyle.colors.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignmentTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _AssignmentTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppStyle.colors.brown : AppStyle.colors.onBrown,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: Text(title, style: TextStyle(color: AppStyle.colors.surface)),
        ),
      ),
    );
  }
}
