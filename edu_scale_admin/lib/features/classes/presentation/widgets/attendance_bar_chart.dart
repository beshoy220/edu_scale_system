import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';

class AttendanceBarChart extends StatelessWidget {
  final Map<String, AttendanceDayStats> data;

  const AttendanceBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppStyle.colors.grey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: _AttendanceBarPainter.barColors.entries.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: e.value,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    e.key.tr(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.entries.map((entry) {
                return Expanded(
                  child: _DayBarGroup(day: entry.key.tr(), stats: entry.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Single day group (4 bars + label) ───────────────────────────────────────

class _DayBarGroup extends StatelessWidget {
  final String day;
  final AttendanceDayStats stats;

  const _DayBarGroup({required this.day, required this.stats});

  @override
  Widget build(BuildContext context) {
    final values = {
      'Present': stats.present,
      'Absent': stats.absent,
      'Late': stats.late,
      'Excused': stats.excused,
    };

    final maxVal = values.values.fold<double>(
      1,
      (prev, v) => v > prev ? v.toDouble() : prev,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: values.entries.map((e) {
            final color = _AttendanceBarPainter.barColors[e.key]!;
            final heightFraction = e.value / maxVal;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _AnimatedBar(
                label: e.key,
                value: e.value,
                heightFraction: heightFraction,
                color: color,
                maxHeight: 120,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          day,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// ─── Single animated bar with hover tooltip ───────────────────────────────────

class _AnimatedBar extends StatefulWidget {
  final String label;
  final num value;
  final double heightFraction;
  final Color color;
  final double maxHeight;

  const _AnimatedBar({
    required this.label,
    required this.value,
    required this.heightFraction,
    required this.color,
    required this.maxHeight,
  });

  @override
  State<_AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _heightAnim;
  bool _hovered = false;
  OverlayEntry? _tooltip;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heightAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    // Small delay per bar creates a staggered feel — caller can pass an index
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _removeTooltip();
    _ctrl.dispose();
    super.dispose();
  }

  void _showTooltip() {
    _removeTooltip();
    final overlay = Overlay.of(context);
    _tooltip = OverlayEntry(
      builder: (_) => Positioned(
        width: 90,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-30, -44),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppStyle.colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.label.tr()}: ${widget.value}%',
                style: TextStyle(color: AppStyle.colors.black, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_tooltip!);
  }

  void _removeTooltip() {
    _tooltip?.remove();
    _tooltip = null;
  }

  @override
  Widget build(BuildContext context) {
    final targetHeight = widget.maxHeight * widget.heightFraction;

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovered = true);
          _showTooltip();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          _removeTooltip();
        },
        child: AnimatedBuilder(
          animation: _heightAnim,
          builder: (_, __) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 10,
              height: (targetHeight * _heightAnim.value).clamp(
                2.0,
                widget.maxHeight,
              ),
              decoration: BoxDecoration(
                color: _hovered ? widget.color : widget.color.withAlpha(220),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: widget.color.withAlpha(140),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Color map ────────────────────────────────────────────────────────────────

class _AttendanceBarPainter {
  static Map<String, Color> barColors = {
    'Present': AppStyle.colors.green,
    'Absent': AppStyle.colors.red,
    'Late': AppStyle.colors.orange,
    'Excused': AppStyle.colors.yellow,
  };
}

// ─── Data model (adjust to match your existing model fields) ──────────────────

class AttendanceDayStats {
  final num present;
  final num absent;
  final num late;
  final num excused;

  const AttendanceDayStats({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });
}
