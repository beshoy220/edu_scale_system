import 'package:edu_scale/student/calendar/data/data_sources/get_student_attendance_remote_data_source.dart';
import 'package:edu_scale/student/calendar/data/models/student_attendance_model.dart';
import 'package:flutter/material.dart';

class StudentAttendanceProvider extends ChangeNotifier {
  final GetStudentAttendanceRemoteDataSource _dataSource =
      GetStudentAttendanceRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  StudentAttendanceModel? attendance;

  Future<void> getAttendance({required DateTime date}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      attendance = await _dataSource.getAttendance(date: date);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({required DateTime date}) async {
    await getAttendance(date: date);
  }

  void clearAttendance() {
    attendance = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
