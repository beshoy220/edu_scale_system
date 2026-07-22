import 'package:edu_scale/student/assignments/data/data_sources/get_student_assignments_remote_data_source.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_model.dart';
import 'package:flutter/material.dart';

class StudentAssignmentsProvider extends ChangeNotifier {
  final GetStudentCurrentAssignmentsRemoteDataSource _remoteDataSource =
      GetStudentCurrentAssignmentsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<StudentAssignmentModel> assignments = [];

  Future<void> getCurrentAssignments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      clear();
      assignments = await _remoteDataSource.getCurrentAssignments();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPastAssignments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      clear();
      assignments = await _remoteDataSource.getPastAssignments();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    assignments.clear();
    errorMessage = null;
    notifyListeners();
  }
}
