import 'package:edu_scale/student/calendar/data/models/student_time_table_session_model.dart';
import 'package:flutter/material.dart';
import 'package:edu_scale/student/calendar/data/data_sources/get_student_time_table_remote_data_source.dart';

class StudentTimeTableProvider extends ChangeNotifier {
  final GetStudentTimeTableRemoteDataSource _dataSource =
      GetStudentTimeTableRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<StudentTimetableSessionModel> sessions = [];

  Future<void> getTimeTableSessions({required int dayOfWeek}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      sessions = await _dataSource.getTimeTableSessions(dayOfWeek: dayOfWeek);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({required int dayOfWeek}) async {
    await getTimeTableSessions(dayOfWeek: dayOfWeek);
  }

  void clearSessions() {
    sessions = [];
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
