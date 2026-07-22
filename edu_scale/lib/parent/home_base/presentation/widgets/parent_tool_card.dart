import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class ParentToolCard extends StatelessWidget {
  const ParentToolCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color,
    this.bottomWidget,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color ?? AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppStyle.colors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: AppStyle.colors.black),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppStyle.colors.black,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.theme.primaryTextTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
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
