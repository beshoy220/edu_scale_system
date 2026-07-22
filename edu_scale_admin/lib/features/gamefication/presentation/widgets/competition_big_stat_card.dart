import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/competition_statistics_model.dart';

class CompetitionBigStatCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String numberDescriptionText;
  final CompetitionStatisticsModel statistics;

  const CompetitionBigStatCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.numberDescriptionText,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final grades = statistics.submissionsPerGrade.entries.toList();

    final highestValue = grades.isEmpty
        ? 1
        : grades.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyle.theme.primaryTextTheme.bodyLarge),

          const SizedBox(height: 2),

          Text(subTitle, style: AppStyle.theme.primaryTextTheme.bodySmall),

          const SizedBox(height: 24),

          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // LEFT SIDE
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      numberDescriptionText,
                      style: AppStyle.theme.primaryTextTheme.bodySmall,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      statistics.totalCompetitionsSubmitted.toString(),
                      style: AppStyle.theme.primaryTextTheme.titleLarge
                          ?.copyWith(
                            fontSize: 48,
                            color: AppStyle.colors.yellow,
                            height: 1,
                          ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 140,
                width: 1,
                color: AppStyle.colors.black.withAlpha(40),
              ),

              const SizedBox(width: 16),

              // BARS SECTION
              Expanded(
                flex: 4,
                child: grades.isEmpty
                    ? SizedBox(
                        height: 160,
                        child: Center(
                          child: Text(
                            'No data',
                            style: AppStyle.theme.primaryTextTheme.bodySmall,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(grades.length, (index) {
                            final entry = grades[index];

                            final percentage = entry.value / highestValue;

                            final barHeight = 120 * percentage;

                            final isHighest = entry.value == highestValue;

                            return _CompetitionGradeBar(
                              label: entry.key,
                              value: entry.value,
                              height: barHeight,
                              isHighlighted: isHighest,
                            );
                          }),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompetitionGradeBar extends StatefulWidget {
  final String label;
  final int value;
  final double height;
  final bool isHighlighted;

  const _CompetitionGradeBar({
    required this.label,
    required this.value,
    required this.height,
    required this.isHighlighted,
  });

  @override
  State<_CompetitionGradeBar> createState() => _CompetitionGradeBarState();
}

class _CompetitionGradeBarState extends State<_CompetitionGradeBar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 180,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // TOOLTIP
            if (isHovered)
              Positioned(
                bottom: widget.height + 34,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyle.colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        color: Colors.black.withAlpha(20),
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.value} ${'played rounds'.tr()}',
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ),
              ),

            // BAR
            MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: double.maxFinite,
                    height: widget.height,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: widget.isHighlighted
                          ? AppStyle.colors.yellow
                          : AppStyle.colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
