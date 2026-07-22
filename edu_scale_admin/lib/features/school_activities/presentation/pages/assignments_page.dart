import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../../../gamefication/presentation/widgets/stat_card.dart';
import '../providers/assignment_statistics_provider.dart';
import '../widgets/assignment_big_stat_card.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentStatisticsProvider>().getAssignmentStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssignmentStatisticsProvider>();

    final statistics = provider.statistics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
                    'Assignments'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'My school assignments'.tr(),
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
            AssignmentBigStatCard(
              title: 'Assignments submissions'.tr(),
              subTitle: 'Assignments submitted by students'.tr(),
              numberDescriptionText: 'Submitted assignments'.tr(),
              statistics:
                  statistics, // Note: expects a model with totalSubmissions, etc.
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    number: statistics.publishedAssignments.toString(),
                    numberColor: AppStyle.colors.green,
                    description: 'Published assignments by teachers'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: StatCard(
                    number: statistics.unpublishedAssignments.toString(),
                    numberColor: AppStyle.colors.orange,
                    description: 'Unpublished assignments by teachers'.tr(),
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
