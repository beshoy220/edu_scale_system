import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_grade_class_model.dart';
import 'package:edu_scale/teacher/quizzes/presentation/pages/teacher_add_quiz_page.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_grade_classes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherQuizAddBottomSheet extends StatefulWidget {
  const TeacherQuizAddBottomSheet({super.key});

  @override
  State<TeacherQuizAddBottomSheet> createState() =>
      _TeacherQuizAddBottomSheetState();
}

class _TeacherQuizAddBottomSheetState extends State<TeacherQuizAddBottomSheet> {
  TextEditingController quizTopicController = TextEditingController();
  DateTime? dueDateDay;
  TimeOfDay? dueDateTime;
  List<int> timerOptions = [10, 15, 20, 25, 30, 45, 60, 75, 90];

  String? validationMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherQuizGradeClassesProvider>().getGradeClasses();
    });
  }

  TeacherQuizGradeClassModel? selectedGradeClass;
  DateTime? quiztimer;
  int? selectedTimerMinutes;

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
                  'Add Quiz',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                Column(
                  children: [
                    TextField(
                      controller: quizTopicController,
                      decoration: InputDecoration(hint: Text('Quiz topic...')),
                    ),

                    SizedBox(height: 12),

                    Builder(
                      builder: (context) {
                        final provider = context
                            .watch<TeacherQuizGradeClassesProvider>();

                        if (provider.isLoading) {
                          return const Center(child: LinearProgressIndicator());
                        }

                        if (provider.errorMessage != null) {
                          return Text(provider.errorMessage!);
                        }

                        final List<TeacherQuizGradeClassModel> items = [];

                        int? lastGradeId;

                        for (final gradeClass in provider.classes) {
                          if (lastGradeId != gradeClass.gradeId) {
                            items.add(
                              TeacherQuizGradeClassModel(
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
                          child: DropdownMenu<TeacherQuizGradeClassModel>(
                            width: 250,
                            enableFilter: false,
                            requestFocusOnTap: false,
                            initialSelection: selectedGradeClass,
                            hintText: 'Select Grade / Class',
                            dropdownMenuEntries: items.map((item) {
                              return DropdownMenuEntry<
                                TeacherQuizGradeClassModel
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
                        TextButton(
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
                        TextButton(
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.colors.grey,
                    foregroundColor: AppStyle.colors.black,
                  ),
                  onPressed: () {
                    if (dueDateDay == null || dueDateTime == null) {
                      setState(() {
                        validationMessage =
                            'Please choose due date before timer';
                      });
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Choose quiz timer'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: timerOptions.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedTimerMinutes =
                                          timerOptions[index];

                                      quiztimer =
                                          DateTime(
                                            dueDateDay!.year,
                                            dueDateDay!.month,
                                            dueDateDay!.day,
                                            dueDateTime!.hour,
                                            dueDateTime!.minute,
                                          ).subtract(
                                            Duration(
                                              minutes: selectedTimerMinutes!,
                                            ),
                                          );
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      '${timerOptions[index]} Mins',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    selectedTimerMinutes == null
                        ? 'Timer'
                        : '$selectedTimerMinutes Mins',
                  ),
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
                        if (quizTopicController.text.isEmpty ||
                            dueDateDay == null ||
                            dueDateTime == null ||
                            selectedGradeClass == null ||
                            quiztimer == null) {
                          setState(() {
                            validationMessage =
                                'Please make sure that quiz topic, grade, due date and due time are not empty';
                          });
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  TeacherAddQuizPage(
                                    quizName: quizTopicController.text,
                                    selectedGradeClass: selectedGradeClass!,
                                    quizStartAt: quiztimer!,
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
                      child: Text('Create Quiz'),
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
