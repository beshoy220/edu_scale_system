import 'package:edu_scale/student/home_base/data/data_sources/student_notification_remote_data_source.dart';
import 'package:edu_scale/student/home_base/data/models/student_notification_model.dart';
import 'package:flutter/material.dart';

class StudentNotificationProvider extends ChangeNotifier {
  final StudentNotificationRemoteDataSource _remoteDataSource =
      StudentNotificationRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<StudentNotificationModel> notifications = [];

  Future<void> getLast50Notifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      notifications = await _remoteDataSource.getLast50Notifications();
    } catch (e) {
      errorMessage = e.toString();
      notifications = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    notifications = [];
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
