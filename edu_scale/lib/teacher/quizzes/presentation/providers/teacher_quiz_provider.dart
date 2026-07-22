import 'package:edu_scale/teacher/quizzes/data/data_sources/get_teacher_quizzes_remote_data_source.dart';
import 'package:edu_scale/teacher/quizzes/data/data_sources/update_teacher_quiz_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../../data/models/teacher_quiz_model.dart';

class TeacherQuizzesProvider extends ChangeNotifier {
  final GetTeacherQuizRemoteDataSource _remoteDataSource =
      GetTeacherQuizRemoteDataSource();

  final UpdateTeacherQuizRemoteDataSource _updateRemoteDataSource =
      UpdateTeacherQuizRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherQuizModel> quizzes = [];

  Future<void> getCurrentQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      quizzes = await _remoteDataSource.getCurrentQuizByTeacherId();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getLast150PastQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      quizzes = await _remoteDataSource.getLast150PastQuizByTeacherId();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePublishState({
    required int quizId,
    required String newPublishState,
  }) async {
    try {
      await _updateRemoteDataSource.updatePublishState(
        quizId: quizId,
        newPublishState: newPublishState,
      );

      final index = quizzes.indexWhere((quiz) => quiz.quizId == quizId);

      if (index != -1) {
        quizzes[index] = quizzes[index].copyWith(
          publishStatus: newPublishState,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearQuizzes() {
    quizzes.clear();
    errorMessage = null;
    notifyListeners();
  }
}
