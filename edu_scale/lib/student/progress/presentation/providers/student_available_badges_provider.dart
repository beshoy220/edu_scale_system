import 'package:edu_scale/student/progress/data/data_sources/get_student_available_badges_remote_data_source.dart';
import 'package:edu_scale/student/progress/data/models/student_available_badge_model.dart';
import 'package:flutter/material.dart';

class StudentAvailableBadgesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<StudentAvailableBadgeModel> badges = [];

  Future<void> getBadges() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      badges =
          await GetStudentAllAvailableBadgesRemoteDataSource.getAllAvailableBadges();
    } catch (e) {
      errorMessage = e.toString();
      badges = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    badges = [];
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
