import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/providers/classe_for_parents_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/themes/themes.dart';

class SelectClassDialog extends StatelessWidget {
  const SelectClassDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final classesProvider = context.watch<ClassesForParentsProvider>();

    return AlertDialog(
      backgroundColor: AppStyle.colors.surface,
      constraints: BoxConstraints(maxWidth: 800),
      title: Text('Select Class'.tr()),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: classesProvider.classes.length,
          itemBuilder: (context, index) {
            final classItem = classesProvider.classes[index];
            return InkWell(
              onTap: () {
                classesProvider.setSelectedClass(classItem);
                Navigator.of(context).pop();
              },
              hoverColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(18),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppStyle.colors.grey,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text('${classItem.grade!.name} - ${classItem.nickname}'),
              ),
            );
          },
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.colors.grey,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Back'.tr()),
        ),
      ],
    );
  }
}
