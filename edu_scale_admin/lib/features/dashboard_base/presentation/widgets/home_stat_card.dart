import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';

class HomeStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const HomeStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: AppStyle.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon),
              ),

              SizedBox(width: 8),

              Text(
                title,
                style: AppStyle.theme.primaryTextTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   ' $title',
              //   style: AppStyle.theme.primaryTextTheme.bodySmall!.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
