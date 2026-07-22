// ------------------------- Reusable Settings Tile -------------------------
import 'package:flutter/material.dart';

import '../../../../core/themes/themes.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? rightSideWidget;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.rightSideWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppStyle.colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 28, color: AppStyle.colors.black),
          ),
          const SizedBox(width: 16),

          // Title and subtitle (flexible)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: AppStyle.colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Value with responsive constraints
          if (rightSideWidget != null) rightSideWidget!,
        ],
      ),
    );
  }
}
