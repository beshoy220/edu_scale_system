import 'package:edu_scale/parent/home_base/data/data_sources/parent_notification_remote_data_source.dart';
import 'package:edu_scale/parent/home_base/data/models/parent_notification_model.dart';
import 'package:flutter/material.dart';

class ParentNotificationProvider extends ChangeNotifier {
  final ParentNotificationRemoteDataSource _remoteDataSource =
      ParentNotificationRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<ParentNotificationModel> notifications = [];

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
