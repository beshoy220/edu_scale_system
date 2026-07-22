import 'package:flutter/material.dart';
import '../../data/data_sources/get_quiz_statistics_remote_data_source.dart';
import '../../data/models/quiz_statistics_model.dart';

class QuizStatisticsProvider extends ChangeNotifier {
  QuizStatisticsModel? statistics;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getQuizStatistics() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final result = await GetQuizStatisticsRemoteDataSource.get();

      statistics = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
