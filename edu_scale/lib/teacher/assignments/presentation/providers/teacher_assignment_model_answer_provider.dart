import 'package:edu_scale/teacher/assignments/data/data_sources/get_teacher_assignment_questions_remote_data_source.dart';
import 'package:edu_scale/teacher/assignments/data/models/teacher_assignment_question_model.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentModelAnswerProvider extends ChangeNotifier {
  final GetTeacherAssignmentQuestionsRemoteDataSource remoteDataSource =
      GetTeacherAssignmentQuestionsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherAssignmentQuestionModel> questions = [];

  Future<void> getQuestions({required int assignmentId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      questions = await remoteDataSource.getQuestions(
        assignmentId: assignmentId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearQuestions() {
    questions.clear();
    errorMessage = null;
    notifyListeners();
  }
}
