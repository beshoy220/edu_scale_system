import 'package:flutter/material.dart';

import '../../data/data_sources/get_school_dashboard_statistics_remote_data_source.dart';
import '../../data/models/school_dashboard_statistics_model.dart';

class SchoolStatisticsProvider extends ChangeNotifier {
  SchoolDashboardStatisticsModel? statistics;

  bool isLoading = false;
  String? errorMessage;

  Future<void> getStatistics() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      statistics = await GetSchoolDashboardStatisticsRemoteDataSource.get();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('SchoolStatisticsProvider Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await getStatistics();
  }

  void clear() {
    statistics = null;
    errorMessage = null;
    notifyListeners();
  }
}
