import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/classes/data/models/class_model.dart';
import 'package:edu_scale_admin/features/classes/presentation/widgets/class_statistics.dart';
import 'package:edu_scale_admin/features/classes/presentation/widgets/classes_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../providers/classes_list_provider.dart';

class MyClassesPage extends StatefulWidget {
  const MyClassesPage({super.key});

  @override
  State<MyClassesPage> createState() => _MyClassesPageState();
}

class _MyClassesPageState extends State<MyClassesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassesListProvider>().getClasses();
    });
  }

  ClassModel? selectedClass;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Classes'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'My school classes'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),
              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: const SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 18),

          (selectedClass != null)
              ? Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedClass = null;
                            });
                          },
                          icon: Icon(CupertinoIcons.back, size: 38),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedClass!.name} ${'Statistics'.tr()}',
                              style: AppStyle.theme.primaryTextTheme.titleSmall,
                            ),

                            // const SizedBox(height: 8),
                            Text(
                              '${'Class ID'.tr()}: ${selectedClass!.id}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ClassStatistics(classId: selectedClass!.id),
                  ],
                )
              : ClassesList(
                  onSelect: (c) {
                    setState(() {
                      selectedClass = c;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
