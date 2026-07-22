import 'package:edu_scale/student/library/data/data_sources/get_student_library_resources_remote_data_source.dart';
import 'package:edu_scale/student/library/data/models/student_library_resources_model.dart';
import 'package:flutter/material.dart';

class StudentLibraryResourcesProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';

  List<StudentLibraryResourceModel> resources = [];

  final GetStudentLibraryResourcesRemoteDataSource _remoteDataSource =
      GetStudentLibraryResourcesRemoteDataSource();

  Future<void> getResources(int subjectId) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      resources = await _remoteDataSource.getResources(subjectId);
    } catch (e) {
      errorMessage = e.toString();
      resources = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void clearResources() {
    resources = [];
    errorMessage = '';
    notifyListeners();
  }
}
