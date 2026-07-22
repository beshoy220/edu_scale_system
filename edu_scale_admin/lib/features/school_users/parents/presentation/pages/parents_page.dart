import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/providers/parents_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../../core/themes/themes.dart';
import '../providers/classe_for_parents_provider.dart';
import '../widgets/add_one_parent_dialog.dart';
import '../widgets/parent_custom_table.dart';
import '../widgets/select_class_dialog.dart';
import '../widgets/view_more_dialog.dart';

class ParentsPage extends StatefulWidget {
  const ParentsPage({super.key});

  @override
  State<ParentsPage> createState() => _ParentsPageState();
}

class _ParentsPageState extends State<ParentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final classesProvider = context.read<ClassesForParentsProvider>();

      /// Auto load first classes
      await classesProvider.loadClasses();

      if (classesProvider.selectedClass != null) {
        if (!mounted) return;

        await context.read<ParentsProvider>().getParentsByClassId(
          classId: classesProvider.selectedClass!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classesProvider = context.watch<ClassesForParentsProvider>();
    final parentProvider = context.watch<ParentsProvider>();

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
                    'Parents'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Parents users of my school'.tr(),
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
                  '${parentProvider.parents.length} ${'Parents'.tr()}',
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
                  '${(classesProvider.selectedClass != null) ? '${classesProvider.selectedClass!.grade!.name} - ${classesProvider.selectedClass!.nickname}' : 'Loading selected class...'} ',
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
                    parentProvider.getParentsByClassId(
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
                  'Add 1 Parent'.tr(),
                  style: AppStyle.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddOneParentDialog(),
                  ).then((v) {
                    parentProvider.getParentsByClassId(
                      classId: classesProvider.selectedClass!.id,
                    );
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
              //   child: Text(
              //     'Add Many Parents',
              //     style: AppStyle.theme.textTheme.bodySmall?.copyWith(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) =>
              //           AlertDialog(constraints: BoxConstraints(minWidth: 800)),
              //     );
              //   },
              // ),
            ],
          ),

          const SizedBox(height: 24),

          if (parentProvider.isLoading)
            LinearProgressIndicator()
          else if (parentProvider.errorMessage != null)
            Text(
              parentProvider.errorMessage!,
              style: TextStyle(color: AppStyle.colors.red),
            )
          else if (parentProvider.parents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Oops, no parents found yet!'.tr(),
                  style: AppStyle.theme.primaryTextTheme.bodyMedium,
                ),
              ),
            )
          else
            ParentCustomTable(
              fitWidth: true,
              shrinkLastColumn: true,
              headersText: [
                'Parent Name'.tr(),
                'Parent Email'.tr(),
                'Parent Phone'.tr(),
                'Student Name'.tr(),
                'Parent Status'.tr(),
                '',
              ],
              rows: parentProvider.parents.map((parent) {
                return [
                  Text(parent.name),
                  Text(parent.email),
                  Text(parent.phone),
                  Text(parent.student.name),
                  Text(
                    parent.status.tr(),
                    style: TextStyle(
                      color: (parent.status == 'active')
                          ? AppStyle.colors.green
                          : (parent.status == 'suspended')
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
                              return ViewMoreDialog(parent: parent);
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
