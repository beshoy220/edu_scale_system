import 'package:edu_scale/teacher/quizzes/data/data_sources/get_teacher_quiz_grade_classes_remote_data_source.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_grade_class_model.dart';
import 'package:flutter/material.dart';

class TeacherQuizGradeClassesProvider extends ChangeNotifier {
  final GetTeacherQuizGradeClassesRemoteDataSource remoteDataSource =
      GetTeacherQuizGradeClassesRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherQuizGradeClassModel> classes = [];

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
