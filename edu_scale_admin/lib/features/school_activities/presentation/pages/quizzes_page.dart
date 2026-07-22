import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../../../gamefication/presentation/widgets/stat_card.dart';
import '../providers/quiz_statistics_provider.dart';
import '../widgets/quiz_big_stat_card.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizStatisticsProvider>().getQuizStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizStatisticsProvider>();

    final statistics = provider.statistics;

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
                    'Quizzes'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'My school quizzes'.tr(),
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
            QuizBigStatCard(
              title: 'Quizzes submissions'.tr(),
              subTitle: 'Quizzes submissioned by students'.tr(),
              numberDescriptionText: 'Submitted quizzes'.tr(),
              statistics: statistics,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    number: statistics.publishedQuizzes.toString(),
                    numberColor: AppStyle.colors.green,
                    description: 'Published quizzes by teachers'.tr(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: StatCard(
                    number: statistics.unpublishedQuizzes.toString(),
                    numberColor: AppStyle.colors.orange,
                    description: 'Unpublished quizzes by teachers'.tr(),
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
