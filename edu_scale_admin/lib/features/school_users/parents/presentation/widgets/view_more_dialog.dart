import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/school_users/parents/data/model/parent_user_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/themes.dart';

class ViewMoreDialog extends StatelessWidget {
  final ParentUserModel parent;
  const ViewMoreDialog({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(minWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      title: Text('${'Parent'.tr()} ${parent.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: ${parent.email}'),
          Text('First time password: ${parent.phone}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}
