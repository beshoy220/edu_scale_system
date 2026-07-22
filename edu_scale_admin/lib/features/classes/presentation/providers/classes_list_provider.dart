import 'package:flutter/material.dart';
import '../../data/data_sources/get_classes_remote_data_source.dart';
import '../../data/models/class_model.dart';

class ClassesListProvider extends ChangeNotifier {
  List<ClassModel> classes = [];
  ClassModel? selectedClass;
  bool isLoadingForClasses = false;
  String? errorMessageForClasses;

  Future<void> getClasses() async {
    isLoadingForClasses = true;
    errorMessageForClasses = null;

    notifyListeners();

    try {
      final result = await GetClassesRemoteDataSource().get();

      classes = result;
    } catch (e) {
      errorMessageForClasses = e.toString();
    } finally {
      isLoadingForClasses = false;

      notifyListeners();
    }
  }

  void clearClassesError() {
    errorMessageForClasses = null;
    notifyListeners();
  }

  void clearClasses() {
    classes = [];
    notifyListeners();
  }

  void setSelectedClass(ClassModel classs) {
    selectedClass = classs;
    notifyListeners();
  }

  // Optional helpers

  List<ClassModel> getClassesByGradeId(int gradeId) {
    return classes.where((e) => e.grade?.id == gradeId).toList();
  }

  List<GradeModel> get grades {
    final Map<int, GradeModel> uniqueGrades = {};

    for (final item in classes) {
      if (item.grade != null) {
        uniqueGrades[item.grade!.id] = item.grade!;
      }
    }

    return uniqueGrades.values.toList();
  }
}
