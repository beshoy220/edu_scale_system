import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/providers/attendance_statistics_provider.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/widgets/attendance_day_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../widgets/attendance_grade_stat_card.dart';
import '../widgets/attendance_stat_card.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceStatisticsProvider>().getAttendanceStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceStatisticsProvider>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'My school attendance.'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: Center(),
              ),
            ],
          ),

          SizedBox(height: 18),

          if (attendanceProvider.isLoading)
            const LinearProgressIndicator()
          else if (attendanceProvider.errorMessage != null)
            Center(
              child: Text(
                attendanceProvider.errorMessage!,
                style: TextStyle(color: AppStyle.colors.red),
              ),
            )
          else if (attendanceProvider.statistics != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AttendanceStatCard(
                    number:
                        '${attendanceProvider.statistics!.overall.presentPercentage}%',
                    numberColor: AppStyle.colors.green,
                    description: 'Present students percentage'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AttendanceStatCard(
                    number:
                        '${attendanceProvider.statistics!.overall.absentPercentage}%',
                    numberColor: AppStyle.colors.red,
                    description: 'Absent students percentage'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AttendanceStatCard(
                    number:
                        '${attendanceProvider.statistics!.overall.latePercentage}%',
                    numberColor: AppStyle.colors.orange,
                    description: 'Late students percentage'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AttendanceStatCard(
                    number:
                        '${attendanceProvider.statistics!.overall.excusedPercentage}%',
                    numberColor: AppStyle.colors.yellow,
                    description: 'Excused students percentage'.tr(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            AttendanceDayStatCard(
              title: 'Attendance by day'.tr(),
              subTitle:
                  'See how attendance varies across different days of the week in the school.'
                      .tr(),
              statistics: attendanceProvider.statistics!,
            ),

            const SizedBox(height: 16),

            AttendanceGradeStatCard(
              title: 'Attendance by grade'.tr(),
              subTitle:
                  'See how attendance varies across different grades in the school.'
                      .tr(),
              statistics: attendanceProvider.statistics!,
            ),
          ],
        ],
      ),
    );
  }
}
