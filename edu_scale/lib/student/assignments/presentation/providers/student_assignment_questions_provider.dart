import 'package:edu_scale/student/assignments/data/data_sources/get_student_assignment_questions_remote_data_source.dart';
import 'package:edu_scale/student/assignments/data/data_sources/submit_student_assignment_answers_remote_data_source.dart';
import 'package:edu_scale/student/assignments/data/models/student_assignment_questions_model.dart';
import 'package:flutter/material.dart';

class StudentAssignmentQuestionsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<StudentAssignmentQuestionsModel> assignmentQuestions = [];

  final GetStudentAssignmentQuestionsRemoteDataSource _getDataSource =
      GetStudentAssignmentQuestionsRemoteDataSource();
  final SubmitStudentAnswersRemoteDataSource _submitDataSource =
      SubmitStudentAnswersRemoteDataSource();

  Future<void> getAssignmentQuestions({required int assignmentId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      assignmentQuestions = await _getDataSource.getAssignmentQuestions(
        assignmentId: assignmentId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearassignmentQuestions() {
    assignmentQuestions = [];
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitStudentAnswers({
    required int assignmentId,
    required Map<int, String> selectedAnswers,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var numberOfCorrectQuestions = 0;
    final answers = <Map<String, dynamic>>[];

    for (final question in assignmentQuestions) {
      final studentAnswer = selectedAnswers[question.id];
      final isCorrect =
          studentAnswer != null && studentAnswer == question.modelAnswer;
      if (isCorrect) {
        numberOfCorrectQuestions++;
      }

      answers.add({
        'assignment_question_id': question.id,
        'answer': studentAnswer ?? '',
        'is_correct': isCorrect,
      });
    }

    try {
      await _submitDataSource.submitStudentAnswers(
        assignmentId: assignmentId,
        numberOfCorrectQuestions: numberOfCorrectQuestions,
        totalNumberOfQuestions: assignmentQuestions.length,
        answers: answers,
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
