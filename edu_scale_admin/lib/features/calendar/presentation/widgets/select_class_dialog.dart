import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/class_model.dart';

class SelectClassDialog extends StatelessWidget {
  final List<ClassModel> classes;

  const SelectClassDialog({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppStyle.colors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Class'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Classes list
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final cls = classes[index];

                  return InkWell(
                    onTap: () {
                      // return selected class
                      Navigator.pop(context, cls);
                    },
                    hoverColor: Colors.transparent,

                    child: Container(
                      padding: const EdgeInsets.all(18),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppStyle.colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text('${cls.grade!.name} - ${cls.nickname}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
