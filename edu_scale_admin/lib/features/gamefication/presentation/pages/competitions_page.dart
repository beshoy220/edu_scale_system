import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/gamefication/presentation/providers/competition_statistics_provider.dart';
import 'package:edu_scale_admin/features/gamefication/presentation/widgets/competition_big_stat_card.dart';
import 'package:edu_scale_admin/features/gamefication/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';

class CompetitionsPage extends StatefulWidget {
  const CompetitionsPage({super.key});

  @override
  State<CompetitionsPage> createState() => _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompetitionStatisticsProvider>().getCompetitionStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompetitionStatisticsProvider>();

    final statistics = provider.statistics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Competitions'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'My school competitions'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: const Center(),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (provider.isLoading)
            const LinearProgressIndicator()
          else if (provider.errorMessage != null)
            Center(
              child: Text(
                provider.errorMessage!,
                style: TextStyle(color: AppStyle.colors.red),
              ),
            )
          else if (statistics != null) ...[
            CompetitionBigStatCard(
              title: 'Competitions Played'.tr(),
              subTitle: 'Competition played rounds by students'.tr(),
              numberDescriptionText: 'Played rounds'.tr(),
              statistics: statistics,
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    number: statistics.teamCompetitionsCount.toString(),
                    numberColor: AppStyle.colors.green,
                    description: 'Team competitions made by teachers'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: StatCard(
                    number: statistics.soloCompetitionsCount.toString(),
                    numberColor: AppStyle.colors.orange,
                    description: 'Solo competitions made by teachers'.tr(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
