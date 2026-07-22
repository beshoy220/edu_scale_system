import 'package:edu_scale/teacher/assignments/data/data_sources/get_teacher_assignment_student_submission_remote_data_source.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_student_submission_model.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentStudentSubmissionsProvider extends ChangeNotifier {
  final GetTeacherAssignmentStudentSubmissionRemoteDataSource remoteDataSource =
      GetTeacherAssignmentStudentSubmissionRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherAssignmentStudentSubmissionModel> studentSubmissions = [];

  Future<void> getStudentSubmissions({required int assignmentId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      studentSubmissions = await remoteDataSource.getStudentSubmissions(
        assignmentId: assignmentId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearStudentSubmissions() {
    studentSubmissions.clear();
    errorMessage = null;
    notifyListeners();
  }
}
