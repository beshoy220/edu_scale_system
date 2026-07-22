import 'package:edu_scale_admin/features/school_users/teachers/data/models/teacher_subject_model.dart';
import 'package:flutter/material.dart';
import '../../data/data_sources/subjects_remote_data_source.dart';

class SubjectProvider extends ChangeNotifier {
  final SubjectsRemoteDataSource _remoteDataSource = SubjectsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherSubjectModel> subjects = [];

  TeacherSubjectModel? selectedSubject;

  /// =========================
  /// LOAD SUBJECTS
  /// =========================

  Future<void> loadSubjects() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _remoteDataSource.getSubjects();

      subjects = response;

      /// Auto select first subject
      if (subjects.isNotEmpty) {
        selectedSubject = subjects.first;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// =========================
  /// SELECT SUBJECT
  /// =========================

  void setSubject(TeacherSubjectModel subject) {
    selectedSubject = subject;
    notifyListeners();
  }

  /// =========================
  /// CLEAR
  /// =========================

  void clearSelectedSubject() {
    selectedSubject = null;
    notifyListeners();
  }
}
