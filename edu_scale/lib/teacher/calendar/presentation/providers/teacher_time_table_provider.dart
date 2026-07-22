import 'package:edu_scale/teacher/calendar/data/data_sources/get_teacher_time_table_remote_data_source.dart';
import 'package:edu_scale/teacher/calendar/data/models/teacher_time_table_model.dart';
import 'package:flutter/material.dart';

class TeacherTimeTableProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<TeacherTimeTableModel> timeTableSessions = [];

  Future<void> loadTimeTableSessions({required int dayOfWeek}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      timeTableSessions = await GetTeacherTimeTableRemoteDataSource()
          .getTimeTableSessions(dayOfWeek: dayOfWeek);
    } catch (e) {
      errorMessage = e.toString();
      timeTableSessions = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearTimeTable() {
    timeTableSessions = [];
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
