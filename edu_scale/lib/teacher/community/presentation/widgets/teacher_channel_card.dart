import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherChannelCard extends StatelessWidget {
  const TeacherChannelCard({
    super.key,
    required this.channelName,
    required this.onTap,
  });

  final String channelName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppStyle.colors.grey,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(CupertinoIcons.person_3)],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channelName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('Click to view'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
