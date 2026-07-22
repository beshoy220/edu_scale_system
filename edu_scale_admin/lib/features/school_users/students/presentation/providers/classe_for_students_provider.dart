import 'package:edu_scale_admin/features/school_users/students/data/models/class_for_students_model.dart';
import 'package:flutter/material.dart';
import '../../data/data_sources/get_classes_for_students_remote_data_source.dart';

class ClassesForStudentsProvider extends ChangeNotifier {
  final GetClassesForStudentsRemoteDataSource _dataSource =
      GetClassesForStudentsRemoteDataSource();

  bool loading = false;
  String? errorMessage;
  List<ClassForStudentsModel> classes = [];

  ClassForStudentsModel? selectedClass;
  ClassForStudentsModel? selectedClassForAddingOneStudent;

  Future<void> loadClasses() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      classes = await _dataSource.get();
      selectedClass = classes.first;
    } catch (e) {
      errorMessage = e.toString();
      classes = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setSelectedClass(ClassForStudentsModel newClasses) {
    selectedClass = newClasses;
    notifyListeners();
  }

  void setSelectedClassForAddingOneStudent(ClassForStudentsModel newClasses) {
    selectedClassForAddingOneStudent = newClasses;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadClasses();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
