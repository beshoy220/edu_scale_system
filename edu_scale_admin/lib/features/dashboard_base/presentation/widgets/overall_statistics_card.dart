import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/themes.dart';
import '../providers/school_statistics_provider.dart';

class OverallStatisticsCard extends StatelessWidget {
  const OverallStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolStatisticsProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: AppStyle.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.chart_bar),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Statistics'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'An overview of the school\'s performance and activities.'
                        .tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${(provider.statistics!.schoolStatistics.classesCount > 9999) ? '10K+' : provider.statistics!.schoolStatistics.classesCount}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.blue,
                      ),
                    ),
                    Text(
                      'Classes'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),

                Spacer(),

                Column(
                  children: [
                    Text(
                      '${(provider.statistics!.schoolStatistics.assignmentsCount > 9999) ? '10K+' : provider.statistics!.schoolStatistics.assignmentsCount}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.green,
                      ),
                    ),
                    Text(
                      'Assignments'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),

                Spacer(),

                Column(
                  children: [
                    Text(
                      '${(provider.statistics!.schoolStatistics.quizzesCount > 9999) ? '10K+' : provider.statistics!.schoolStatistics.quizzesCount}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.yellow,
                      ),
                    ),
                    Text(
                      'Quizzes'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),

                Spacer(),

                Column(
                  children: [
                    Text(
                      '${(provider.statistics!.schoolStatistics.libraryResourcesCount > 9999) ? '10K+' : provider.statistics!.schoolStatistics.libraryResourcesCount}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.red,
                      ),
                    ),
                    Text(
                      'Library Files'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),

                Spacer(),

                Column(
                  children: [
                    Text(
                      '${(provider.statistics!.schoolStatistics.competitionsCount > 9999) ? '10K+' : provider.statistics!.schoolStatistics.competitionsCount}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.orange,
                      ),
                    ),
                    Text(
                      'Competitions'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),

                Spacer(),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
