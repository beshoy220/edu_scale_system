import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/themes.dart';
import '../../data/models/student_user_model.dart';

class ViewMoreDialog extends StatelessWidget {
  final StudentUserModel student;
  const ViewMoreDialog({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(minWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      title: Text('${'Studnet'.tr()} ${student.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${'Email'.tr()}: ${student.email}'),
          Text('${'First time password'.tr()}: ${student.parent.phone}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'.tr()),
        ),
      ],
    );
  }
}
