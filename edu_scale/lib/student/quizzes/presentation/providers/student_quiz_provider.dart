import 'package:edu_scale/student/quizzes/data/data_sources/get_student_quizzes_remote_data_source.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_model.dart';
import 'package:flutter/material.dart';

class StudentQuizzesProvider extends ChangeNotifier {
  final GetStudentCurrentQuizzesRemoteDataSource _remoteDataSource =
      GetStudentCurrentQuizzesRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<StudentQuizModel> quizzes = [];

  Future<void> getCurrentQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      clear();
      quizzes = await _remoteDataSource.getCurrentQuizzes();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPastQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      clear();
      quizzes = await _remoteDataSource.getPastQuizzes();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    quizzes.clear();
    errorMessage = null;
    notifyListeners();
  }
}
