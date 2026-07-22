import 'package:edu_scale/teacher/assignments/data/data_sources/get_teacher_assignment_grade_classes_remote_data_source.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_grade_class_model.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentGradeClassesProvider extends ChangeNotifier {
  final GetTeacherAssignmentGradeClassesRemoteDataSource remoteDataSource =
      GetTeacherAssignmentGradeClassesRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherAssignmentGradeClassModel> classes = [];

  Future<void> getGradeClasses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      classes = await remoteDataSource.getGradesAndClassesAssignedToTeacher();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearClasses() {
    classes.clear();
    errorMessage = null;
    notifyListeners();
  }
}
