import 'package:edu_scale_admin/features/school_activities/data/data_sources/get_attendance_statistics_remote_data_source.dart';
import 'package:edu_scale_admin/features/school_activities/data/models/attendance_statistics_model.dart';
import 'package:flutter/material.dart';

class AttendanceStatisticsProvider extends ChangeNotifier {
  AttendanceStatisticsModel? statistics;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getAttendanceStatistics() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await GetAttendanceStatisticsRemoteDataSource.get();
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

  // Optional: reset the Statistics data
  void reset() {
    statistics = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
