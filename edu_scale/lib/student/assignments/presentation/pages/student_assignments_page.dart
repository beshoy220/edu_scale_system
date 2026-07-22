import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/assignments/presentation/widgets/student_assignment_info_bottom_sheet.dart';
import 'package:edu_scale/student/assignments/presentation/widgets/student_current_assignments_display.dart';
import 'package:edu_scale/student/assignments/presentation/widgets/student_past_assignments_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  bool showCurrentAssignment = true;

  @override
  Widget build(BuildContext context) {
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
                                StudentAssignmentInfoBottomSheet(),
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

            Expanded(
              child: showCurrentAssignment
                  ? StudentCurrentAssignmentsDisplay()
                  : StudentPastAssignmentsDisplay(),
            ),
          ],
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
