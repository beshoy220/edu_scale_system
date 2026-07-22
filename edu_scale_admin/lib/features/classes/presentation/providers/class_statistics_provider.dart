import 'package:flutter/material.dart';
import '../../data/data_sources/class_statistics_remote_data_source.dart';
import '../../data/models/class_statistics_model.dart';

class ClassStatisticsProvider extends ChangeNotifier {
  ClassStatisticsModel? statistics;
  bool isLoading = false;
  String? errorMessage;

  /// optional: if you want to store multiple class loads (history / caching UI)
  List<ClassStatisticsModel> statisticsHistory = [];

  Future<void> getClassStatistics({required int classId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ClassStatisticsRemoteDataSource remoteDataSource =
          ClassStatisticsRemoteDataSource();

      final result = await remoteDataSource.getClassStatistics(
        classId: classId,
      );

      statistics = result;

      // store in list (history)
      statisticsHistory.add(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// optional: refresh current class
  Future<void> refresh({required int classId}) async {
    await getClassStatistics(classId: classId);
  }

  /// optional: clear everything
  void clear() {
    statistics = null;
    statisticsHistory.clear();
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
