import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/calendar/presentation/providers/time_table_provider.dart';
import 'package:edu_scale_admin/features/calendar/presentation/widgets/add_time_table_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/class_model.dart';
import '../widgets/select_class_dialog.dart';
import '../widgets/time_table_time_line.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  int selectedDayIndex = 0;

  final List<Map<String, String>> weekDays = [
    {'full': 'Saturday', 'short': 'Sat'},
    {'full': 'Sunday', 'short': 'Sun'},
    {'full': 'Monday', 'short': 'Mon'},
    {'full': 'Tuesday', 'short': 'Tue'},
    {'full': 'Wednesday', 'short': 'Wed'},
    {'full': 'Thursday', 'short': 'Thu'},
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimeTableProvider>().getClasses();
    });
  }

  void _loadSessions(ClassModel? selectedClass) {
    if (selectedClass != null) {
      context.read<TimeTableProvider>().getSessions(
        gradeId: selectedClass.grade!.id,
        classId: selectedClass.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimeTableProvider>();
    final selectedClass = provider.selectedClass;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (selectedClass != null && provider.sessions.isEmpty) {
    //     _loadSessions(selectedClass);
    //   }
    // });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Table'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'My school time table'.tr(),
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

          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.green,
                ),
                onPressed: () async {
                  final selectedClassFromDialog = await showDialog<ClassModel>(
                    context: context,
                    builder: (_) =>
                        SelectClassDialog(classes: provider.classes),
                  );

                  if (selectedClassFromDialog != null) {
                    provider.setSelectedClass(selectedClassFromDialog);

                    _loadSessions(selectedClassFromDialog);
                  }
                },
                child: Text(
                  selectedClass == null
                      ? 'Select class'.tr()
                      : '${selectedClass.grade!.name} - ${selectedClass.nickname}',
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddTimeTableSession(
                      selectedDayIndex: selectedDayIndex,
                      classesList: provider.classes,
                    ),
                  ).then((_) {
                    _loadSessions(selectedClass);
                  });
                },
                child: Text('+ Add session'.tr()),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 95,
            width: double.maxFinite,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                final item = weekDays[index];
                final isSelected = selectedDayIndex == index;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppStyle.colors.green
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppStyle.colors.grey,
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['full']!.tr(),
                              style: AppStyle.theme.primaryTextTheme.bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppStyle.colors.surface
                                        : AppStyle.colors.black.withAlpha(100),
                                  ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item['short']!.tr(),
                              style: TextStyle(
                                fontSize: 28,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppStyle.colors.surface
                                    : AppStyle.colors.black.withAlpha(160),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              isSelected ? 'Selected'.tr() : 'Tap'.tr(),
                              style: AppStyle.theme.primaryTextTheme.bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppStyle.colors.surface
                                        : AppStyle.colors.black.withAlpha(100),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          if (selectedClass == null)
            Center(child: Text('Please select a class to view'.tr()))
          else if (provider.isLoadingForSessions)
            const LinearProgressIndicator()
          else if (provider.errorMessageForSessions != null)
            Text(
              provider.errorMessageForSessions!,
              style: TextStyle(color: AppStyle.colors.red),
            )
          else
            Column(
              children: [
                Divider(thickness: 1, color: AppStyle.colors.grey),

                const SizedBox(height: 10),

                TimeTableTimeline(dayOfWeek: selectedDayIndex + 1),
              ],
            ),
        ],
      ),
    );
  }
}
