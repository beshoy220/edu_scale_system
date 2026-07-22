import 'package:edu_scale/student/library/data/data_sources/get_student_subjects_based_on_timetable_remote_data_source.dart';
import 'package:edu_scale/student/library/data/models/student_subjects_based_on_timetable_model.dart';
import 'package:flutter/material.dart';

class StudentLibrarySubjectsProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  List<StudentSubjectsBasedOnTimetableModel> subjects = [];

  final GetStudentSubjectsBasedOnTimetableRemoteDataSource _remoteDataSource =
      GetStudentSubjectsBasedOnTimetableRemoteDataSource();

  Future<void> getSubjects() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      subjects = await _remoteDataSource.getStudentSubjectsBasedOnTimetable();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearSubjects() {
    subjects = [];
    errorMessage = '';
    notifyListeners();
  }
}
