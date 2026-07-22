import 'package:edu_scale_admin/features/school_users/parents/data/data_sources/get_classes_for_parents_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../../data/model/class_for_parents_model.dart';

class ClassesForParentsProvider extends ChangeNotifier {
  final GetClassesForParentsRemoteDataSource _dataSource =
      GetClassesForParentsRemoteDataSource();

  bool loading = false;
  String? errorMessage;
  List<ClassForParentsModel> classes = [];

  ClassForParentsModel? selectedClass;
  ClassForParentsModel? selectedClassForAddingOneParent;

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

  void setSelectedClass(ClassForParentsModel newClasses) {
    selectedClass = newClasses;
    notifyListeners();
  }

  void setSelectedClassForAddingOneParent(ClassForParentsModel newClasses) {
    selectedClassForAddingOneParent = newClasses;
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
