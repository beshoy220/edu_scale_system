import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/providers/create_parents_students_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/themes/themes.dart';
import '../../data/model/class_for_parents_model.dart';
import '../providers/classe_for_parents_provider.dart';

class AddOneParentDialog extends StatefulWidget {
  const AddOneParentDialog({super.key});

  @override
  State<AddOneParentDialog> createState() => _AddOneParentDialogState();
}

class _AddOneParentDialogState extends State<AddOneParentDialog> {
  TextEditingController parentName = TextEditingController();
  TextEditingController parentPhone = TextEditingController();
  TextEditingController studentName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final classProvider = context.read<ClassesForParentsProvider>();
    final createProvider = context.read<CreateParentsStudnetsProvider>();

    return AlertDialog(
      constraints: const BoxConstraints(minWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      title: Text('Adding one Student/Parent user'.tr()),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: parentName,
            decoration: InputDecoration(hintText: 'Parent Name'.tr()),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: parentPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Parent Phone'.tr()),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: 10),

          TextField(
            controller: studentName,
            decoration: InputDecoration(hintText: 'Student Name'.tr()),
          ),

          const SizedBox(height: 10),

          DropdownMenu<ClassForParentsModel>(
            width: 200,
            enableFilter: false,
            requestFocusOnTap: false,

            initialSelection: classProvider.selectedClassForAddingOneParent,

            dropdownMenuEntries: classProvider.classes
                .map(
                  (clas) => DropdownMenuEntry<ClassForParentsModel>(
                    value: clas,
                    label: '${clas.grade!.name} - ${clas.name}',
                  ),
                )
                .toList(),

            onSelected: (selected) async {
              if (selected == null) return;
              classProvider.setSelectedClassForAddingOneParent(selected);
            },
          ),
        ],
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

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          onPressed: () async {
            if (classProvider.selectedClassForAddingOneParent == null ||
                studentName.text.isEmpty ||
                parentName.text.isEmpty ||
                parentPhone.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please fill all fields and select a class'.tr(),
                  ),
                  backgroundColor: AppStyle.colors.red,
                ),
              );
            } else {
              await createProvider
                  .createUsers(
                    gradeId: classProvider.selectedClass!.grade!.id,
                    classId: classProvider.selectedClass!.id,
                    users: [
                      {
                        'student_name': studentName.text,
                        'parent_name': parentName.text,
                        'parent_phone': parentPhone.text,
                      },
                    ],
                  )
                  .then((onValue) {
                    if (!context.mounted) return;

                    Navigator.of(context).pop();
                  });
            }
          },

          child: Text(
            'Save'.tr(),
            style: AppStyle.theme.textTheme.bodySmall?.copyWith(
              color: AppStyle.colors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
