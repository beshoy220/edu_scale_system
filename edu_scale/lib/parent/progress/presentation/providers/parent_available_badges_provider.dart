import 'package:edu_scale/parent/progress/data/data_sources/get_parent_available_badges_remote_data_source.dart';
import 'package:edu_scale/parent/progress/data/models/parent_available_badge_model.dart';
import 'package:flutter/material.dart';

class ParentAvailableBadgesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<ParentAvailableBadgeModel> badges = [];

  Future<void> getBadges() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      badges =
          await GetParentAllAvailableBadgesRemoteDataSource.getAllAvailableBadges();
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
