import 'package:flutter/material.dart';
import '../../data/data_sources/get_assignment_statistics_remote_data_source.dart';
import '../../data/models/assignment_statistics_model.dart';

class AssignmentStatisticsProvider extends ChangeNotifier {
  AssignmentStatisticsModel? statistics;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getAssignmentStatistics() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final result = await GetAssignmentStatisticsRemoteDataSource.get();

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
