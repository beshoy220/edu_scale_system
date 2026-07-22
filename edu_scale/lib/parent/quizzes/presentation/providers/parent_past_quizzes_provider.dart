import 'package:edu_scale/parent/quizzes/data/data_sources/get_parent_past_quizzes_remote_data_source.dart';
import 'package:edu_scale/parent/quizzes/data/models/parent_past_quiz_model.dart';
import 'package:flutter/material.dart';

class ParentPastQuizzesProvider extends ChangeNotifier {
  final GetParentPastQuizzesRemoteDataSource _dataSource =
      GetParentPastQuizzesRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<ParentPastQuizModel> pastQuizzesList = [];

  Future<void> getPastQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pastQuizzesList = await _dataSource.getLast150PastQuizzes();
    } catch (e) {
      errorMessage = e.toString();
      pastQuizzesList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    pastQuizzesList = [];
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
