import 'package:edu_scale/teacher/assignments/data/data_sources/get_teacher_assignments_remote_data_source.dart';
import 'package:edu_scale/teacher/assignments/data/data_sources/update_teacher_assignment_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../../data/models/teacher_assignment_model.dart';

class TeacherAssignmentsProvider extends ChangeNotifier {
  final GetTeacherAssignmentRemoteDataSource _remoteDataSource =
      GetTeacherAssignmentRemoteDataSource();

  final UpdateTeacherAssignmentRemoteDataSource _updateRemoteDataSource =
      UpdateTeacherAssignmentRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherAssignmentModel> assignments = [];

  Future<void> getCurrentAssignments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      assignments = await _remoteDataSource.getCurrentAssignmentByTeacherId();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getLast150PastAssignments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      assignments = await _remoteDataSource
          .getLast150PastAssignmentByTeacherId();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePublishState({
    required int assignmentId,
    required String newPublishState,
  }) async {
    try {
      await _updateRemoteDataSource.updatePublishState(
        assignmentId: assignmentId,
        newPublishState: newPublishState,
      );

      final index = assignments.indexWhere(
        (assignment) => assignment.assignmentId == assignmentId,
      );

      if (index != -1) {
        assignments[index] = assignments[index].copyWith(
          publishStatus: newPublishState,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearAssignments() {
    assignments.clear();
    errorMessage = null;
    notifyListeners();
  }
}
