import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/providers/subjects_provider.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/providers/teachers_list_provider.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/widgets/add_one_teacher_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../widgets/teacher_custom_table.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final teacherProvider = context.read<TeachersListProvider>();

      /// Auto load first teachers teachers
      await teacherProvider.loadTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppStyle.theme.primaryTextTheme;
    final teacherProvider = context.watch<TeachersListProvider>();

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
                  Text('Teachers'.tr(), style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Teacher users of my school'.tr(),
                    style: textTheme.bodySmall,
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
                  '${teacherProvider.teachers.length} ${'Teachers'.tr()}',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Accessible Search + Filter
          Row(
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
                  'Add 1 Teacher'.tr(),
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async {
                  final subjectProvider = context.read<SubjectProvider>();
                  await subjectProvider.loadSubjects();

                  if (!context.mounted) return;

                  return showDialog(
                    context: context,
                    builder: (_) => AddOneTeacherUserDialog(),
                  ).then((onValue) {
                    // refresh teachers after adding new one
                    teacherProvider.loadTeachers();
                  });
                },
              ),

              const SizedBox(width: 8),

              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppStyle.colors.grey,
              //     foregroundColor: Colors.black,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 18,
              //       vertical: 18,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(14),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: Text(
              //     'Add Many Teachers',
              //     style: AppStyle.theme.textTheme.bodySmall?.copyWith(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 24),

          if (teacherProvider.isLoading)
            LinearProgressIndicator()
          else if (teacherProvider.error != null)
            Text(
              teacherProvider.error!,
              style: TextStyle(color: AppStyle.colors.red),
            )
          else if (teacherProvider.teachers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Oops, no teachers found yet!'.tr(),
                  style: textTheme.bodyMedium,
                ),
              ),
            )
          else
            TeacherCustomTable(
              fitWidth: true,
              shrinkLastColumn: true,
              headersText: [
                'Teacher Name'.tr(),
                'Email'.tr(),
                'Phone'.tr(),
                'Subject'.tr(),
                'Status'.tr(),
                '',
              ],
              rows: teacherProvider.teachers.map((teacher) {
                return [
                  Text(teacher.name),
                  Text(teacher.email),
                  Text(teacher.phone ?? 'No phone'.tr()),
                  Text(teacher.subjectName ?? 'No subject'.tr()),
                  Text(
                    teacher.status.tr(),
                    style: TextStyle(
                      color: (teacher.status == 'active')
                          ? AppStyle.colors.green
                          : (teacher.status == 'suspended')
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
                        // case 'suspend':
                        //   break;
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
                              return AlertDialog(
                                constraints: BoxConstraints(minWidth: 800),
                                title: Text(teacher.name),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${'Email'.tr()}: ${teacher.email}'),
                                    Text(
                                      '${'Phone'.tr()}: ${teacher.phone ?? 'No phone'}',
                                    ),
                                    Text(
                                      '${'Subject'.tr()}: ${teacher.subjectName ?? 'No subject'}',
                                    ),
                                    Text(
                                      '${'First time password'.tr()}: ${teacher.phone ?? ''}',
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Close'.tr()),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // PopupMenuItem(
                      //   value: 'suspend',
                      //   child: Text('Suspend'),
                      // ),
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
