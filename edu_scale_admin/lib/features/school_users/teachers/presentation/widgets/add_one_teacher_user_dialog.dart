import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/themes/themes.dart';
import '../../data/models/teacher_subject_model.dart';
import '../providers/create_teachers_provider.dart';
import '../providers/subjects_provider.dart';

class AddOneTeacherUserDialog extends StatelessWidget {
  AddOneTeacherUserDialog({super.key});

  final TextEditingController teacherName = TextEditingController();
  final TextEditingController teacherPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final teacherProvider = context.watch<CreateTeachersProvider>();
    final subjectProvider = context.watch<SubjectProvider>();

    return AlertDialog(
      constraints: const BoxConstraints(minWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      title: Text('Adding one Teacher user'.tr()),

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: teacherName,
            decoration: InputDecoration(hintText: 'Teacher Name'.tr()),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: teacherPhone,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: 'Teacher Phone'.tr()),
          ),

          const SizedBox(height: 10),

          if (subjectProvider.isLoading)
            Text('Subjects are loading...'.tr())
          else if (subjectProvider.subjects.isEmpty)
            Text('No subjects found'.tr())
          else
            DropdownMenu<TeacherSubjectModel>(
              width: 200,
              enableFilter: false,
              requestFocusOnTap: false,
              initialSelection: subjectProvider.selectedSubject,
              dropdownMenuEntries: subjectProvider.subjects
                  .map(
                    (subject) =>
                        DropdownMenuEntry(value: subject, label: subject.name),
                  )
                  .toList(),
              onSelected: (selected) {
                if (selected != null) {
                  subjectProvider.setSubject(selected);
                }
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
          onPressed: teacherProvider.isLoading
              ? null
              : () => Navigator.pop(context),
          child: Text('Back'.tr()),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: teacherProvider.isLoading
                ? AppStyle.colors.grey
                : AppStyle.colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          onPressed: teacherProvider.isLoading
              ? null
              : () async {
                  final selectedSubject = subjectProvider.selectedSubject;

                  if (selectedSubject == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppStyle.colors.red,
                        content: Text('Subject cannot be null'.tr()),
                      ),
                    );
                    return;
                  }

                  await teacherProvider.createUsers(
                    selectedSubject.id,
                    selectedSubject.name,
                    [
                      {
                        'teacher_name': teacherName.text.trim(),
                        'teacher_phone': teacherPhone.text.trim(),
                      },
                    ],
                  );

                  if (!context.mounted) return;

                  if (teacherProvider.isSuccess &&
                      teacherProvider.failedUsers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppStyle.colors.green,
                        content: Text('Teacher created successfully'.tr()),
                      ),
                    );

                    Navigator.pop(context);
                  } else {
                    final error =
                        teacherProvider.errorMessage ??
                        (teacherProvider.failedUsers.isNotEmpty
                            ? teacherProvider.failedUsers.first['reason']
                                  .toString()
                            : 'Unknown error');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppStyle.colors.red,
                        content: Text(error),
                      ),
                    );
                  }
                },

          child: teacherProvider.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
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
