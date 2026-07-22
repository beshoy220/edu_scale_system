import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';

/// A flexible table widget.
///
/// [fitWidth] = false (default): horizontally scrollable, every column shrinks to its content.
/// [fitWidth] = true: fills parent width, columns stretch.
///   - "No." column (if showIndex = true) always shrinks.
///   - [shrinkLastColumn] = true makes the last column also shrink (great for action buttons).
///
class StudentCustomTable extends StatelessWidget {
  final List<String> headersText;
  final List<List<Widget>> rows;
  final bool showIndex;
  final bool fitWidth;
  final bool shrinkLastColumn;

  const StudentCustomTable({
    super.key,
    required this.headersText,
    required this.rows,
    this.showIndex = true,
    this.fitWidth = false,
    this.shrinkLastColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppStyle.theme.primaryTextTheme;
    final colors = AppStyle.colors;

    final hasIndex = showIndex;
    final totalColumns = (hasIndex ? 1 : 0) + headersText.length;

    // Build column widths
    Map<int, TableColumnWidth>? columnWidths;

    if (!fitWidth) {
      // Scrollable mode: every column shrinks to its content
      columnWidths = {
        for (int i = 0; i < totalColumns; i++) i: const IntrinsicColumnWidth(),
      };
    } else {
      // Fill-parent-width mode
      columnWidths = {};

      // Index column always shrinks
      if (hasIndex) {
        columnWidths[0] = const IntrinsicColumnWidth();
      }

      if (shrinkLastColumn) {
        // Last column shrinks, all other (non-index) columns flex
        final firstDataColumn = hasIndex ? 1 : 0;
        final lastColumnIndex = totalColumns - 1;

        for (int i = firstDataColumn; i < lastColumnIndex; i++) {
          columnWidths[i] = const FlexColumnWidth();
        }
        columnWidths[lastColumnIndex] = const IntrinsicColumnWidth();
      }
      // else: no extra widths -> remaining columns will use default FlexColumnWidth (equal share)
    }

    final table = Table(
      columnWidths: columnWidths,
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: colors.brown,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          children: [
            if (hasIndex)
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'No.'.tr(),
                  style: textTheme.bodyMedium?.copyWith(color: colors.surface),
                ),
              ),
            ...headersText.map(
              (header) => Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  header,
                  style: textTheme.bodyMedium?.copyWith(color: colors.surface),
                ),
              ),
            ),
          ],
        ),
        // Data rows
        for (int i = 0; i < rows.length; i++)
          TableRow(
            decoration: BoxDecoration(color: i.isOdd ? colors.grey : null),
            children: [
              if (hasIndex)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('${i + 1}'),
                ),
              ...rows[i].map(
                (cell) =>
                    Padding(padding: const EdgeInsets.all(8), child: cell),
              ),
            ],
          ),
      ],
    );

    // Return with or without horizontal scroll
    return fitWidth
        ? table // fills parent width automatically because Table expands
        : SingleChildScrollView(scrollDirection: Axis.horizontal, child: table);
  }
}
