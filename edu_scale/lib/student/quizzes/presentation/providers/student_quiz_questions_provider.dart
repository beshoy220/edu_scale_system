import 'package:edu_scale/student/quizzes/data/data_sources/get_student_quiz_questions_remote_data_source.dart';
import 'package:edu_scale/student/quizzes/data/data_sources/submit_student_quiz_answers_remote_data_source.dart';
import 'package:edu_scale/student/quizzes/data/models/student_quiz_questions_model.dart';
import 'package:flutter/material.dart';

class StudentQuizQuestionsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<StudentQuizQuestionsModel> quizQuestions = [];

  final GetStudentQuizQuestionsRemoteDataSource _getDataSource =
      GetStudentQuizQuestionsRemoteDataSource();
  final SubmitStudentAnswersRemoteDataSource _submitDataSource =
      SubmitStudentAnswersRemoteDataSource();

  Future<void> getQuizQuestions({required int quizId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      quizQuestions = await _getDataSource.getQuizQuestions(quizId: quizId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearquizQuestions() {
    quizQuestions = [];
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitStudentAnswers({
    required int quizId,
    required Map<int, String> selectedAnswers,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var numberOfCorrectQuestions = 0;
    final answers = <Map<String, dynamic>>[];

    for (final question in quizQuestions) {
      final studentAnswer = selectedAnswers[question.id];
      if (studentAnswer == null) {
        continue;
      }

      final isCorrect = studentAnswer == question.modelAnswer;
      if (isCorrect) {
        numberOfCorrectQuestions++;
      }

      answers.add({
        'quiz_question_id': question.id,
        'answer': studentAnswer,
        'is_correct': isCorrect,
      });
    }
    try {
      await _submitDataSource.submitStudentAnswers(
        quizId: quizId,
        numberOfCorrectQuestions: numberOfCorrectQuestions,
        totalNumberOfQuestions: quizQuestions.length,
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
