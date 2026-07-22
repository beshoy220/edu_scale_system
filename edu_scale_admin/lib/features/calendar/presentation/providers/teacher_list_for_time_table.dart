import 'package:edu_scale_admin/features/calendar/data/data_sources/get_subjects_remote_data_source.dart';
import 'package:flutter/material.dart';
import '../../data/models/teacher_model.dart';

class TeacherListForTimeTable extends ChangeNotifier {
  List<TeacherModel> teachers = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> getTeachers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await GetSubjectsRemoteDataSource().get();

      teachers = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;

    notifyListeners();
  }

  void clearTeachers() {
    teachers = [];

    notifyListeners();
  }

  // Helpers

  List<TeacherModel> getTeachersBySubjectId(int subjectId) {
    return teachers.where((e) => e.subjectId == subjectId).toList();
  }

  TeacherModel? getTeacherById(String teacherId) {
    try {
      return teachers.firstWhere((e) => e.id == teacherId);
    } catch (_) {
      return null;
    }
  }
}
