import 'package:edu_scale_admin/features/school_activities/data/models/quiz_statistics_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';

class QuizBigStatCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String numberDescriptionText;
  final QuizStatisticsModel statistics;

  const QuizBigStatCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.numberDescriptionText,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final grades = statistics.submissionsByGrade.entries.toList();

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
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                      statistics.totalSubmissions.toString(),
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

                            return _QuizGradeBar(
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

class _QuizGradeBar extends StatefulWidget {
  final String label;
  final int value;
  final double height;
  final bool isHighlighted;

  const _QuizGradeBar({
    required this.label,
    required this.value,
    required this.height,
    required this.isHighlighted,
  });

  @override
  State<_QuizGradeBar> createState() => _QuizGradeBarState();
}

class _QuizGradeBarState extends State<_QuizGradeBar> {
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
                    '${widget.value} submissions',
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
                    margin: const EdgeInsets.symmetric(horizontal: 6),
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
