import 'package:flutter/material.dart';
import '../../data/data_sources/teachers_remote_data_source.dart';
import '../../data/models/teacher_user_model.dart';

class TeachersListProvider extends ChangeNotifier {
  final TeachersRemoteDataSource _remoteDataSource = TeachersRemoteDataSource();

  bool isLoading = false;
  String? error;

  List<TeacherUserModel> teachers = [];
  TeacherUserModel? selectedTeacher;

  Future<void> loadTeachers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _remoteDataSource.getTeachers();

      teachers = response;

      /// Auto select first teacher
      if (teachers.isNotEmpty) {
        selectedTeacher = teachers.first;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  void setTeacher(TeacherUserModel teacher) {
    selectedTeacher = teacher;
    notifyListeners();
  }

  void clearSelectedTeacher() {
    selectedTeacher = null;
    notifyListeners();
  }
}
