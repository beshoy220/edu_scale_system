import 'package:edu_scale_admin/features/school_users/parents/data/data_sources/get_parents_remote_data_source.dart';
import 'package:edu_scale_admin/features/school_users/parents/data/model/parent_user_model.dart';
import 'package:flutter/material.dart';

class ParentsProvider extends ChangeNotifier {
  final GetParentsRemoteDataSource _remoteDataSource =
      GetParentsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  List<ParentUserModel> parents = [];

  Future<void> getParentsByClassId({required int classId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      parents = await _remoteDataSource.getParentsByClassId(classId: classId);
    } catch (e) {
      errorMessage = e.toString();
      parents = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    parents = [];
    errorMessage = null;
    notifyListeners();
  }
}
