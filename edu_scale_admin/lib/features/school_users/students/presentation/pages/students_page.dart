import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/providers/classe_for_students_provider.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/widgets/add_many_students_dialog.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/widgets/select_class_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../providers/students_provider.dart';
import '../widgets/add_one_student_dialog.dart';
import '../widgets/student_custom_table.dart';
import '../widgets/view_more_dialog.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final classesProvider = context.read<ClassesForStudentsProvider>();

      /// Auto load first classes
      await classesProvider.loadClasses();

      if (classesProvider.selectedClass != null) {
        if (!mounted) return;

        await context.read<StudentsProvider>().getStudentsByClassId(
          classId: classesProvider.selectedClass!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classesProvider = context.watch<ClassesForStudentsProvider>();
    final studentsProvider = context.watch<StudentsProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Student users of my school'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: Row(
                  children: [
                    IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                medium: Text(
                  '${studentsProvider.students.length} ${'Students'.tr()}',
                  style: AppStyle.theme.primaryTextTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Accessible Search + Filter
          Wrap(
            runSpacing: 8,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.grey,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  '${(classesProvider.selectedClass != null) ? '${classesProvider.selectedClass!.grade!.name} - ${classesProvider.selectedClass!.nickname}' : 'Loading selected class...'.tr()} ',
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SelectClassDialog();
                    },
                  ).then((v) {
                    studentsProvider.getStudentsByClassId(
                      classId: classesProvider.selectedClass!.id,
                    );
                  });
                },
              ),

              const SizedBox(width: 8),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.grey,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Add 1 Student'.tr(),
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddOneStudentDialog(),
                  ).then((_) {
                    studentsProvider.getStudentsByClassId(
                      classId: classesProvider.selectedClass!.id,
                    );
                  });
                },
              ),

              const SizedBox(width: 8),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.grey,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Add Many Students'.tr(),
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddManyStudentsDialog(
                      avaliableClasses: classesProvider.classes,
                    ),
                  ).then((_) {
                    studentsProvider.getStudentsByClassId(
                      classId: classesProvider.selectedClass!.id,
                    );
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (studentsProvider.isLoading)
            LinearProgressIndicator()
          else if (studentsProvider.errorMessage != null)
            Text(
              studentsProvider.errorMessage!,
              style: TextStyle(color: AppStyle.colors.red),
            )
          else if (studentsProvider.students.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Oops, no students found yet!'.tr(),
                  style: AppStyle.theme.primaryTextTheme.bodyMedium,
                ),
              ),
            )
          else
            StudentCustomTable(
              fitWidth: true,
              shrinkLastColumn: true,
              headersText: [
                'Student Name'.tr(),
                'Student Email'.tr(),
                'Parent Name'.tr(),
                'Phone Phone'.tr(),
                'Studnet Status'.tr(),
                '',
              ],
              rows: studentsProvider.students.map((student) {
                return [
                  Text(student.name),
                  Text(student.email),
                  Text(student.parent.name),
                  Text(student.parent.phone),
                  Text(
                    student.status.tr(),
                    style: TextStyle(
                      color: (student.status == 'active')
                          ? AppStyle.colors.green
                          : (student.status == 'suspended')
                          ? AppStyle.colors.red
                          : AppStyle.colors.black.withAlpha(230),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_outlined),
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Text('View More'.tr()),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ViewMoreDialog(student: student);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ];
              }).toList(),
            ),
        ],
      ),
    );
  }
}
