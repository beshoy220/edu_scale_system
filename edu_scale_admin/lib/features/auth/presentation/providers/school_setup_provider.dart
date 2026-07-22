import 'package:flutter/material.dart';
import 'package:edu_scale_admin/core/app_meta/default_grades_list.dart';
import 'package:edu_scale_admin/core/app_meta/default_subjects_list.dart';
import 'package:edu_scale_admin/core/app_meta/educational_systems_list.dart';
import 'package:edu_scale_admin/core/app_meta/default_class_list.dart';
import '../../data/data_sources/remote/set_up_school.dart';

class SchoolSetupProvider extends ChangeNotifier {
  // Controllers
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController schoolAddressController = TextEditingController();
  final TextEditingController classCapacityController = TextEditingController();

  String selectedEducationalSystem = educationalSystemsList.first;
  List<String> selectedGrades = List.from(defaultGradesList);
  List<String> selectedSubjects = List.from(defaultSubjectsList);
  List<String> availableSubjects = List.from(defaultSubjectsList);

  // Classes per grade
  Map<String, List<String>> selectedClassesPerGrade = {};

  // Pre‑defined available classes for each grade (static, never changes)
  static Map<String, List<String>> gradeToAvailableClasses = defaultGradesList
      .asMap()
      .map((index, grade) => MapEntry(grade, defaultClassesList));

  SchoolSetupProvider() {
    for (var grade in defaultGradesList) {
      selectedClassesPerGrade[grade] = [];
    }
  }

  void toggleGrade(String grade, bool? selected) {
    final wasSelected = selectedGrades.contains(grade);
    if (selected == true && !wasSelected) {
      selectedGrades.add(grade);
      notifyListeners();
    } else if (selected != true && wasSelected) {
      selectedGrades.remove(grade);
      notifyListeners();
    }
  }

  void toggleSubject(String subject, bool? selected) {
    final wasSelected = selectedSubjects.contains(subject);
    if (selected == true && !wasSelected) {
      selectedSubjects.add(subject);
      notifyListeners();
    } else if (selected != true && wasSelected) {
      selectedSubjects.remove(subject);
      notifyListeners();
    }
  }

  void updateEducationalSystem(String? system) {
    if (system != null && system != selectedEducationalSystem) {
      selectedEducationalSystem = system;
      notifyListeners();
    }
  }

  void toggleClassForGrade(String grade, String className, bool? selected) {
    final list = selectedClassesPerGrade.putIfAbsent(grade, () => []);
    final isSelected = list.contains(className);
    if (selected == true && !isSelected) {
      list.add(className);
      notifyListeners();
    } else if (selected != true && isSelected) {
      list.remove(className);
      notifyListeners();
    }
  }

  bool isClassSelectedForGrade(String grade, String className) {
    return selectedClassesPerGrade[grade]?.contains(className) ?? false;
  }

  void addCustomSubject(String subject) {
    subject = subject.trim();

    if (subject.isEmpty) return;

    // Prevent duplicates (case insensitive)
    if (availableSubjects.any(
      (e) => e.toLowerCase() == subject.toLowerCase(),
    )) {
      return;
    }

    availableSubjects.add(subject);
    selectedSubjects.add(subject); // Automatically selected
    notifyListeners();
  }

  void printSchoolSetup() {
    debugPrint('========== SCHOOL SETUP DATA ==========');
    debugPrint('School Name: ${schoolNameController.text}');
    debugPrint('School Address: ${schoolAddressController.text}');
    debugPrint('Class Capacity: ${classCapacityController.text}');
    debugPrint('Educational System: $selectedEducationalSystem');
    debugPrint('Selected Grades: ${selectedGrades.join(', ')}');
    debugPrint('Selected Subjects: ${selectedSubjects.join(', ')}');
    debugPrint('--- Classes per Grade ---');
    for (var grade in selectedGrades) {
      final classes = selectedClassesPerGrade[grade] ?? [];
      debugPrint('  $grade: ${classes.isEmpty ? 'none' : classes.join(', ')}');
    }
    debugPrint('=======================================');
  }

  void setUpSchoolInDatabase() async {
    SetUpSchool school = SetUpSchool();

    school.updateSchoolData({
      'name': schoolNameController.text,
      'address': schoolAddressController.text,
      'class_max_capacity': classCapacityController.text,
      'educational_system': selectedEducationalSystem,
      'status': 'active',
    });

    final gradesList = await school.setGrade(selectedGrades);

    school
        .setClasses(
          gradesList: gradesList,
          selectedClassesPerGrade: selectedClassesPerGrade,
        )
        .then((_) {
          school.setChannels();
        });

    school.setSubjects(selectedSubjects);
  }

  @override
  void dispose() {
    schoolNameController.dispose();
    schoolAddressController.dispose();
    classCapacityController.dispose();
    super.dispose();
  }
}
