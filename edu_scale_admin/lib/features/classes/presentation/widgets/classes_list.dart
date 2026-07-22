import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/class_model.dart';
import '../providers/classes_list_provider.dart';

class ClassesList extends StatefulWidget {
  final Function(ClassModel) onSelect;

  const ClassesList({super.key, required this.onSelect});

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassesListProvider>();

    final classes = provider.classes;
    final grades = provider.grades;
    return Column(
      children: [
        // ERROR STATE
        if (provider.errorMessageForClasses != null)
          Text(
            provider.errorMessageForClasses!,
            style: TextStyle(color: AppStyle.colors.red),
          ),

        // LOADING STATE
        if (provider.isLoadingForClasses)
          const Padding(
            padding: EdgeInsets.all(20),
            child: LinearProgressIndicator(),
          )
        else
        // EMPTY STATE
        if (classes.isEmpty)
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('No classes found'.tr()),
          )
        else
          // GRADES LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              final gradeClasses = provider.getClassesByGradeId(grade.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GradeSection(
                  gradeName: grade.name,
                  classes: gradeClasses,
                  selectedClass: provider.selectedClass,
                  onSelect: (classModel) {
                    context.read<ClassesListProvider>().setSelectedClass(
                      classModel,
                    );

                    widget.onSelect(classModel);
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

class GradeSection extends StatelessWidget {
  final String gradeName;
  final List<ClassModel> classes;
  final ClassModel? selectedClass;
  final Function(ClassModel) onSelect;

  const GradeSection({
    super.key,
    required this.gradeName,
    required this.classes,
    required this.selectedClass,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(gradeName, style: AppStyle.theme.primaryTextTheme.titleSmall),

        const SizedBox(height: 10),

        Wrap(
          spacing: 12,
          children: classes.map((classModel) {
            // final isSelected = selectedClass?.id == classModel.id;

            return InkWell(
              onTap: () => onSelect(classModel),

              child: Container(
                width: MediaQuery.of(context).size.width > 600
                    ? 340
                    : double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppStyle.colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(Icons.class_, color: AppStyle.colors.green),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${classModel.grade!.name} - ${classModel.nickname}',
                            style: AppStyle.theme.primaryTextTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('Click to view details'.tr()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
