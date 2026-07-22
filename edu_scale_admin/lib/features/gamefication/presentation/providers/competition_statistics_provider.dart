import 'package:flutter/material.dart';
import '../../data/data_sources/get_competition_statistics_remote_data_source.dart';
import '../../data/models/competition_statistics_model.dart';

class CompetitionStatisticsProvider extends ChangeNotifier {
  CompetitionStatisticsModel? statistics;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getCompetitionStatistics() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final result = await GetCompetitionStatisticsRemoteDataSource.get();

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
