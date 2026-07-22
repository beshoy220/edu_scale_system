import 'package:flutter/material.dart';
import '../../data/data_sources/admin_remote_data_source.dart';
import '../../data/models/admin_user_model.dart';

class AdminsListProvider extends ChangeNotifier {
  final AdminRemoteDataSource _remoteDataSource = AdminRemoteDataSource();

  bool isLoading = false;
  String? error;
  List<AdminUserModel> admins = [];

  Future<void> loadAdmins() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _remoteDataSource.getAdmin();

      admins = response;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    admins = [];
    error = null;
    notifyListeners();
  }
}
