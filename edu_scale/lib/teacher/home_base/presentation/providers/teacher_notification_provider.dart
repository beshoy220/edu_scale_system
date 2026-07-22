import 'package:edu_scale/teacher/home_base/data/data_sources/teacher_notification_remote_data_source.dart';
import 'package:edu_scale/teacher/home_base/data/models/teacher_notification_model.dart';
import 'package:flutter/material.dart';

class TeacherNotificationProvider extends ChangeNotifier {
  final TeacherNotificationRemoteDataSource _remoteDataSource =
      TeacherNotificationRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<TeacherNotificationModel> notifications = [];

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
