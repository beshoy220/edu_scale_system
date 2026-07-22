import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_grade_class_model.dart';
import 'package:edu_scale/teacher/assignments/presentation/pages/teacher_add_assignment_page.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_grade_classes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherAssignmentAddBottomSheet extends StatefulWidget {
  const TeacherAssignmentAddBottomSheet({super.key});

  @override
  State<TeacherAssignmentAddBottomSheet> createState() =>
      _TeacherAssignmentAddBottomSheetState();
}

class _TeacherAssignmentAddBottomSheetState
    extends State<TeacherAssignmentAddBottomSheet> {
  TextEditingController assignmentTopicController = TextEditingController();
  DateTime? dueDateDay;
  TimeOfDay? dueDateTime;

  String? validationMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherAssignmentGradeClassesProvider>().getGradeClasses();
    });
  }

  TeacherAssignmentGradeClassModel? selectedGradeClass;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 8),

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

                const SizedBox(height: 16),

                const Text(
                  'Add Assignment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                Column(
                  children: [
                    TextField(
                      controller: assignmentTopicController,
                      decoration: InputDecoration(
                        hint: Text('Assignment topic...'),
                      ),
                    ),

                    SizedBox(height: 12),

                    Builder(
                      builder: (context) {
                        final provider = context
                            .watch<TeacherAssignmentGradeClassesProvider>();

                        if (provider.isLoading) {
                          return const Center(child: LinearProgressIndicator());
                        }

                        if (provider.errorMessage != null) {
                          return Text(provider.errorMessage!);
                        }

                        final List<TeacherAssignmentGradeClassModel> items = [];

                        int? lastGradeId;

                        for (final gradeClass in provider.classes) {
                          if (lastGradeId != gradeClass.gradeId) {
                            items.add(
                              TeacherAssignmentGradeClassModel(
                                gradeId: gradeClass.gradeId,
                                gradeName: gradeClass.gradeName,
                                classId: null,
                                className: null,
                              ),
                            );

                            lastGradeId = gradeClass.gradeId;
                          }

                          items.add(gradeClass);
                        }

                        return SizedBox(
                          width: double.maxFinite,
                          child: DropdownMenu<TeacherAssignmentGradeClassModel>(
                            width: 250,
                            enableFilter: false,
                            requestFocusOnTap: false,
                            initialSelection: selectedGradeClass,
                            hintText: 'Select Grade / Class',
                            dropdownMenuEntries: items.map((item) {
                              return DropdownMenuEntry<
                                TeacherAssignmentGradeClassModel
                              >(
                                value: item,
                                label: item.classId == null
                                    ? '${item.gradeName} - Whole Grade'
                                    : '${item.gradeName} - ${item.className}',
                              );
                            }).toList(),
                            onSelected: (selected) {
                              setState(() {
                                selectedGradeClass = selected;
                              });
                            },
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.colors.grey,
                            foregroundColor: AppStyle.colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            setState(() {
                              dueDateDay = selectedDate;
                            });
                          },
                          child: Text(
                            dueDateDay == null
                                ? 'Due date day'
                                : '${dueDateDay!.year}-${dueDateDay!.month}-${dueDateDay!.day}',
                          ),
                        ),

                        SizedBox(width: 8),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.colors.grey,
                            foregroundColor: AppStyle.colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            setState(() {
                              dueDateTime = selectedTime;
                            });
                          },
                          child: Text(
                            dueDateTime == null
                                ? 'Due date time'
                                : '${dueDateTime!.hour}:${dueDateTime!.minute}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  validationMessage != null ? validationMessage.toString() : '',
                  style: TextStyle(color: AppStyle.colors.red),
                ),

                SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        if (assignmentTopicController.text.isEmpty ||
                            dueDateDay == null ||
                            dueDateTime == null ||
                            selectedGradeClass == null) {
                          setState(() {
                            validationMessage =
                                'Please make sure that assignment topic, grade, due date and due time are not empty';
                          });
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  TeacherAddAssignmentPage(
                                    assignmentName:
                                        assignmentTopicController.text,
                                    selectedGradeClass: selectedGradeClass!,
                                    dueDate: DateTime(
                                      dueDateDay!.year,
                                      dueDateDay!.month,
                                      dueDateDay!.day,
                                      dueDateTime!.hour,
                                      dueDateTime!.minute,
                                    ),
                                  ),
                            ),
                          );
                        }
                      },
                      child: Text('Create Assignment'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
