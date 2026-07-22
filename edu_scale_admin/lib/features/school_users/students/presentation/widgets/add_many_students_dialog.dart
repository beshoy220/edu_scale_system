import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/widgets/student_custom_table.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/class_for_students_model.dart';
import '../../data/models/imported_student_model.dart';
import '../providers/create_studnets_parents_provider.dart';

class AddManyStudentsDialog extends StatefulWidget {
  final List<ClassForStudentsModel> avaliableClasses;

  const AddManyStudentsDialog({super.key, required this.avaliableClasses});

  @override
  State<AddManyStudentsDialog> createState() => _AddManyStudentsDialogState();
}

class _AddManyStudentsDialogState extends State<AddManyStudentsDialog> {
  final List<ImportedStudent> students = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      title: Text('Adding many Student/Parent user'.tr()),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please use only the Excel template below to add multiple students and their parents at\nonce to prevent any problems during importing.'
                      .tr(),
                  style: AppStyle.theme.primaryTextTheme.bodyMedium,
                ),

                SizedBox(height: 8),

                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        downloadExcelFromAssets();
                      },
                      child: Text('Download Excel Template'.tr()),
                    ),

                    SizedBox(width: 8),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        importExcel().then((_) {
                          setState(() {});
                        });
                      },
                      child: Text('Import Excel'.tr()),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 18),

            students.isEmpty
                ? const Center()
                : ImportedStudents(
                    students: students,
                    avaliableClasses: widget.avaliableClasses,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadExcelFromAssets() async {
    final byteData = await rootBundle.load('assets/import_many_students.xlsx');
    final bytes = byteData.buffer.asUint8List();

    await FilePicker.platform.saveFile(
      fileName: 'schema template.xlsx',
      bytes: bytes,
    );
  }

  Future<void> importExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null) return;
    final Uint8List bytes = result.files.first.bytes!;
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;

    // First row = headers
    final headers = sheet.rows.first
        .map((cell) => cell?.value.toString() ?? '')
        .toList();

    // Clear previous data
    students.clear();

    // Remaining rows = data
    for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
      final row = sheet.rows[rowIndex];
      final Map<String, dynamic> rowData = {};

      for (int colIndex = 0; colIndex < headers.length; colIndex++) {
        rowData[headers[colIndex]] = colIndex < row.length
            ? row[colIndex]?.value?.toString()
            : null;
      }

      students.add(ImportedStudent.fromMap(rowData));
    }
  }
}

class ImportedStudents extends StatefulWidget {
  final List<ImportedStudent> students;
  final List<ClassForStudentsModel> avaliableClasses;

  const ImportedStudents({
    super.key,
    required this.students,
    required this.avaliableClasses,
  });

  @override
  State<ImportedStudents> createState() => _ImportedStudentsState();
}

class _ImportedStudentsState extends State<ImportedStudents> {
  List<StudentProblem> problems = [];
  bool isImporting = false;

  bool hasProblem(ImportedStudent student) {
    return problems.any((p) => p.student == student);
  }

  void validateAndStoreProblems() {
    final newProblems = <StudentProblem>[];

    for (final student in widget.students) {
      final hasMatch = widget.avaliableClasses.any(
        (classItem) =>
            classItem.grade?.name == student.grade &&
            classItem.name == student.studentClass,
      );

      if (!hasMatch) {
        newProblems.add(
          StudentProblem(
            student: student,
            problem:
                'No matching class for grade "${student.grade}" and class "${student.studentClass}".'
                    .tr(
                      namedArgs: {
                        'grade': student.grade,
                        'class': student.studentClass,
                      },
                    ),
          ),
        );
      }
    }

    setState(() {
      problems = newProblems;
    });
  }

  Future<void> importStudents() async {
    validateAndStoreProblems();

    if (problems.isNotEmpty) {
      return;
    }

    setState(() {
      isImporting = true;
    });

    try {
      final provider = context.read<CreateStudnetsParentsProvider>();

      /// Group students by class
      final Map<int, List<ImportedStudent>> groupedStudents = {};

      for (final student in widget.students) {
        final matchedClass = widget.avaliableClasses.firstWhere(
          (classItem) =>
              classItem.grade?.name == student.grade &&
              classItem.name == student.studentClass,
        );

        groupedStudents.putIfAbsent(matchedClass.id, () => []);
        groupedStudents[matchedClass.id]!.add(student);
      }

      /// Create users per class
      for (final entry in groupedStudents.entries) {
        final classId = entry.key;

        final classModel = widget.avaliableClasses.firstWhere(
          (c) => c.id == classId,
        );

        await provider.createUsers(
          gradeId: classModel.grade!.id,
          classId: classModel.id,
          users: entry.value
              .map(
                (student) => {
                  'student_name': student.studentName,
                  'parent_name': student.parentName,
                  'parent_phone': student.parentPhone,
                },
              )
              .toList(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All students imported successfully.'.tr()),
          backgroundColor: AppStyle.colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import failed: $e'.tr(namedArgs: {'e': e.toString()})),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentCustomTable(
          fitWidth: true,
          headersText: [
            'Student Name'.tr(),
            'Parent Name'.tr(),
            'Parent Phone'.tr(),
            'Grade'.tr(),
            'Class'.tr(),
          ],
          rows: [
            for (final student in widget.students) _buildStudentRow(student),
          ],
        ),

        const SizedBox(height: 12),

        if (problems.isNotEmpty) _buildProblemList(),

        const SizedBox(height: 12),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: isImporting ? null : importStudents,
          child: isImporting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Import all to the system'.tr()),
        ),
      ],
    );
  }

  List<Widget> _buildStudentRow(ImportedStudent student) {
    final isProblematic = hasProblem(student);

    final textStyle = isProblematic
        ? TextStyle(color: AppStyle.colors.surface, fontWeight: FontWeight.bold)
        : null;

    final cellColor = isProblematic ? AppStyle.colors.red.withAlpha(200) : null;

    Widget buildCell(String text) {
      return Container(
        color: cellColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(text, style: textStyle),
      );
    }

    return [
      buildCell(student.studentName),
      buildCell(student.parentName),
      buildCell(student.parentPhone),
      buildCell(student.grade),
      buildCell(student.studentClass),
    ];
  }

  Widget _buildProblemList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${problems.length} student(s) cannot be imported:'.tr(
              namedArgs: {'problems.length': problems.length.toString()},
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          ...problems.map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${p.student.studentName}: ${p.problem}'),
            ),
          ),
        ],
      ),
    );
  }
}
