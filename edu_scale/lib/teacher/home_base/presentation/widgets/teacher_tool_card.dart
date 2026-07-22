import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class TeacherToolCard extends StatelessWidget {
  const TeacherToolCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color,
    this.isWide = false,
    this.bottomWidget,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isWide;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final orange = color != null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        // height: isWide ? 110 : 190,
        width: double.maxFinite,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color ?? AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: orange
                          ? AppStyle.colors.surface.withAlpha(60)
                          : AppStyle.colors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: orange ? AppStyle.colors.surface : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              // fontSize: 16,
                              color: AppStyle.colors.black,
                            ),
                          ),

                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.theme.primaryTextTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey.shade700,
                                  // fontSize: 15,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 6),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: orange
                          ? AppStyle.colors.surface.withAlpha(60)
                          : AppStyle.colors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: orange ? AppStyle.colors.surface : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      // fontSize: 16,
                      color: orange
                          ? AppStyle.colors.surface
                          : AppStyle.colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    maxLines: isWide ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.theme.primaryTextTheme.bodySmall?.copyWith(
                      color: orange
                          ? AppStyle.colors.surface.withAlpha(250)
                          : Colors.grey.shade700,
                    ),
                  ),

                  if (bottomWidget != null) ...[
                    const SizedBox(height: 10),
                    bottomWidget!,
                  ],
                ],
              ),
      ),
    );
  }
}
