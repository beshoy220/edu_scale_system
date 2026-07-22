import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/calendar/presentation/providers/time_table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/themes/themes.dart';
import '../../data/models/class_model.dart';
import '../../data/models/teacher_model.dart';
import '../providers/teacher_list_for_time_table.dart';

class AddTimeTableSession extends StatefulWidget {
  final int selectedDayIndex;
  final List<ClassModel> classesList;

  const AddTimeTableSession({
    super.key,
    required this.selectedDayIndex,
    required this.classesList,
  });

  @override
  State<AddTimeTableSession> createState() => _AddTimeTableSessionState();
}

class _AddTimeTableSessionState extends State<AddTimeTableSession> {
  TeacherModel? selectedTeacher;
  ClassModel? selectedClass;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final TextEditingController roomController = TextEditingController();

  final List<String> days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherListForTimeTable>().getTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherListForTimeTable>();

    return Dialog(
      constraints: const BoxConstraints(maxWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Time Table Session'.tr(),
                      style: AppStyle.theme.primaryTextTheme.titleMedium,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// DAY
              Text(
                'Day'.tr(),
                style: AppStyle.theme.primaryTextTheme.bodyMedium,
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(days[widget.selectedDayIndex].tr()),
              ),

              const SizedBox(height: 18),

              /// CLASS
              Text(
                'Class'.tr(),
                style: AppStyle.theme.primaryTextTheme.bodyMedium,
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<ClassModel>(
                hint: Text('Grade - Class'.tr()),
                initialValue: selectedClass,
                items: widget.classesList.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text('${item.grade?.name} - ${item.nickname}'),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedClass = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.errorMessage != null)
                Text(provider.errorMessage!)
              else
                DropdownButtonFormField<TeacherModel>(
                  hint: Text('Teacher/Subject'.tr()),
                  initialValue: selectedTeacher,
                  items: provider.teachers.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        '${item.name} (${item.subjectName ?? 'No Subject'.tr()})',
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedTeacher = value;
                    });
                  },
                ),

              const SizedBox(height: 18),

              /// START / END
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.colors.grey,
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },

                      child: Text(
                        startTime == null
                            ? 'Start Time'.tr()
                            : startTime!.format(context),
                        style: TextStyle(color: AppStyle.colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.colors.grey,
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },

                      child: Text(
                        endTime == null
                            ? 'End Time'.tr()
                            : endTime!.format(context),
                        style: TextStyle(color: AppStyle.colors.black),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// ROOM
              TextField(
                controller: roomController,
                decoration: InputDecoration(hint: Text('Room...'.tr())),
              ),

              const SizedBox(height: 18),

              const SizedBox(height: 28),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),

                  onPressed: () async {
                    /// VALIDATION
                    if (selectedClass == null ||
                        selectedTeacher == null ||
                        startTime == null ||
                        endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields.'.tr())),
                      );

                      return;
                    }

                    final startMinutes =
                        (startTime!.hour * 60) + startTime!.minute;
                    final endMinutes = (endTime!.hour * 60) + endTime!.minute;

                    if (endMinutes <= startMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'End time must be after start time.'.tr(),
                          ),
                        ),
                      );

                      return;
                    }

                    /// ADD SESSION
                    final success = await context
                        .read<TimeTableProvider>()
                        .addSession(
                          gradeId: selectedClass!.grade!.id,
                          classId: selectedClass!.id,
                          subjectId: selectedTeacher!.subjectId!,
                          teacherId: selectedTeacher!.id,
                          dayOfWeek: widget.selectedDayIndex + 1,
                          startTime: startTime!,
                          endTime: endTime!,
                          room: roomController.text,
                        );

                    if (success && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Session added successfully.'.tr()),
                        ),
                      );
                    }
                  },

                  child: Text('Create Session'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
