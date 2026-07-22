import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> chooseSubjectDialoge(
  BuildContext context,
  List<Map<String, dynamic>> subjects,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppStyle.colors.surface,
      title: const Text('Subjects List'),
      content: SizedBox(
        width: 1000,
        height: 500,

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: subjects
                .map(
                  (subject) => Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppStyle.colors.black.withAlpha(5),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(subject),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.school_outlined),
                            SizedBox(width: 12),
                            Text(
                              subject['name'],
                              style: AppStyle.theme.primaryTextTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
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
          child: Text('Back'),
        ),
      ],
    ),
  );
}
