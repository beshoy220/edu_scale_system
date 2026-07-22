import 'package:edu_scale/teacher/quizzes/data/data_sources/get_teacher_quiz_student_submission_remote_data_source.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_student_submission_model.dart';
import 'package:flutter/material.dart';

class TeacherQuizStudentSubmissionsProvider extends ChangeNotifier {
  final GetTeacherQuizStudentSubmissionRemoteDataSource remoteDataSource =
      GetTeacherQuizStudentSubmissionRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherQuizStudentSubmissionModel> studentSubmissions = [];

  Future<void> getStudentSubmissions({required int quizId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      studentSubmissions = await remoteDataSource.getStudentSubmissions(
        quizId: quizId,
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
