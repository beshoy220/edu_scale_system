import 'package:flutter/material.dart';

import '../../../../core/themes/themes.dart';
import '../../data/models/attendance_statistics_model.dart';

class AttendanceGradeStatCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final AttendanceStatisticsModel statistics;

  const AttendanceGradeStatCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.statistics,
  });

  static const double chartHeight = 220;
  static const double labelHeight = 24;
  static const double maxBarHeight = 150;
  static const double minBarHeight = 8;

  @override
  Widget build(BuildContext context) {
    final grades = statistics.byGrade.entries.toList();

    final highestValue = grades.isEmpty
        ? 1
        : grades.map((e) => e.value.present).reduce((a, b) => a > b ? a : b);

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

          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Optional Y Axis
                const SizedBox(width: 0),

                const SizedBox(width: 12),

                Expanded(
                  child: grades.isEmpty
                      ? Center(
                          child: Text(
                            'No data',
                            style: AppStyle.theme.primaryTextTheme.bodySmall,
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(grades.length, (index) {
                            final entry = grades[index];

                            final total = entry.value.present;

                            final percentage = highestValue == 0
                                ? 0.0
                                : total / highestValue;

                            final barHeight = (maxBarHeight * percentage).clamp(
                              minBarHeight,
                              maxBarHeight,
                            );

                            final isHighest = total == highestValue;

                            return Expanded(
                              child: _GradeBar(
                                label: entry.key,
                                height: barHeight,
                                present: entry.value.present,
                                absent: entry.value.absent,
                                late: entry.value.late,
                                excused: entry.value.excused,
                                isHighlighted: isHighest,
                              ),
                            );
                          }),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeBar extends StatefulWidget {
  final String label;
  final double height;
  final int present;
  final int absent;
  final int late;
  final int excused;
  final bool isHighlighted;

  const _GradeBar({
    required this.label,
    required this.height,
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
    required this.isHighlighted,
  });

  @override
  State<_GradeBar> createState() => _GradeBarState();
}

class _GradeBarState extends State<_GradeBar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    const chartHeight = AttendanceGradeStatCard.chartHeight;
    const labelHeight = AttendanceGradeStatCard.labelHeight;

    final safeHeight = widget.height.clamp(
      AttendanceGradeStatCard.minBarHeight,
      AttendanceGradeStatCard.maxBarHeight,
    );

    return SizedBox(
      height: chartHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          if (isHovered)
            Positioned(
              bottom: safeHeight + labelHeight + 12,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 180),
                child: Material(
                  elevation: 6,
                  color: AppStyle.colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TooltipRow(
                          color: Colors.green,
                          text: '${widget.present} Present',
                        ),
                        const SizedBox(height: 4),
                        _TooltipRow(
                          color: Colors.red,
                          text: '${widget.absent} Absent',
                        ),
                        const SizedBox(height: 4),
                        _TooltipRow(
                          color: Colors.orange,
                          text: '${widget.late} Late',
                        ),
                        const SizedBox(height: 4),
                        _TooltipRow(
                          color: Colors.blue,
                          text: '${widget.excused} Excused',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  height: safeHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: widget.isHighlighted
                        ? AppStyle.colors.yellow
                        : AppStyle.colors.orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.theme.primaryTextTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TooltipRow extends StatelessWidget {
  final Color color;
  final String text;

  const _TooltipRow({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: AppStyle.theme.primaryTextTheme.bodySmall),
      ],
    );
  }
}
