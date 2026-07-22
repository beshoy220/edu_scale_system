import 'package:edu_scale/teacher/quizzes/data/data_sources/get_teacher_quiz_questions_remote_data_source.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_question_model.dart';
import 'package:flutter/material.dart';

class TeacherQuizModelAnswerProvider extends ChangeNotifier {
  final GetTeacherQuizQuestionsRemoteDataSource remoteDataSource =
      GetTeacherQuizQuestionsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;

  List<TeacherQuizQuestionModel> questions = [];

  Future<void> getQuestions({required int quizId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      questions = await remoteDataSource.getQuestions(quizId: quizId);
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
