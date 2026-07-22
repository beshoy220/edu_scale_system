import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';

class AttendanceStatCard extends StatelessWidget {
  final String number;
  final Color numberColor;
  final String description;

  const AttendanceStatCard({
    super.key,
    required this.number,
    required this.numberColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppStyle.theme.primaryTextTheme.titleLarge?.copyWith(
              color: numberColor,
              fontSize: 48,
            ),
          ),
          Text(description, style: AppStyle.theme.primaryTextTheme.bodyLarge),
        ],
      ),
    );
  }
}
