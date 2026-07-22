import 'package:edu_scale/teacher/quizzes/data/data_sources/teacher_quiz_upload_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_upload_model.dart';

/// Editable draft of a single answer option, backed by a
/// [TextEditingController] so it can be bound straight to a text field.
class TeacherQuizOptionDraft {
  final TextEditingController controller;

  TeacherQuizOptionDraft({String text = ''})
    : controller = TextEditingController(text: text);

  void dispose() => controller.dispose();
}

/// Editable draft of a single question.
class TeacherQuizQuestionDraft {
  final TextEditingController titleController;
  final List<TeacherQuizOptionDraft> options;
  int correctIndex; // -1 = none selected

  TeacherQuizQuestionDraft()
    : titleController = TextEditingController(),
      options = [TeacherQuizOptionDraft(), TeacherQuizOptionDraft()],
      correctIndex = -1;

  /// Converts this draft into the plain data model used for upload.
  TeacherQuizUploadQuestionModel toModel() {
    return TeacherQuizUploadQuestionModel(
      questionText: titleController.text.trim(),
      options: options.map((o) => o.controller.text.trim()).toList(),
      correctIndex: correctIndex,
    );
  }

  void dispose() {
    titleController.dispose();
    for (final option in options) {
      option.dispose();
    }
  }
}

/// Manages the whole "create quiz" editing session: the list of
/// question drafts, navigation between them, and uploading the final
/// result through [TeacherQuizUploadRemoteDataSource].
class TeacherQuizUploadProvider extends ChangeNotifier {
  TeacherQuizUploadProvider({
    required this.quizName,
    required this.gradeId,
    required this.quizStartAt,
    required this.dueDate,
    this.classId,
    TeacherQuizUploadRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource =
           remoteDataSource ?? TeacherQuizUploadRemoteDataSource(),
       _questions = [TeacherQuizQuestionDraft()];

  static const int maxQuestions = 20;
  static const int maxOptions = TeacherQuizUploadQuestionModel.maxOptions;

  final String quizName;
  final int gradeId;
  final int? classId;
  final DateTime quizStartAt;
  final DateTime dueDate;

  final TeacherQuizUploadRemoteDataSource _remoteDataSource;
  final List<TeacherQuizQuestionDraft> _questions;

  int _currentIndex = 0;
  bool _isUploading = false;
  String? _errorMessage;

  List<TeacherQuizQuestionDraft> get questions => List.unmodifiable(_questions);
  int get currentIndex => _currentIndex;
  int get questionCount => _questions.length;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  bool get canGoBack => _currentIndex > 0;

  TeacherQuizQuestionDraft get currentQuestion => _questions[_currentIndex];

  // ---------------- Question navigation ----------------

  void goToQuestion(int index) {
    if (index < 0 || index >= _questions.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  void goBack() {
    if (!canGoBack) return;
    _currentIndex--;
    notifyListeners();
  }

  /// Adds a new question. Returns an error message if the max question
  /// count was reached, or `null` on success.
  String? addQuestion() {
    if (_questions.length >= maxQuestions) {
      return 'Maximum of $maxQuestions questions reached';
    }
    _questions.add(TeacherQuizQuestionDraft());
    _currentIndex = _questions.length - 1;
    notifyListeners();
    return null;
  }

  /// Deletes the question at [index]. Returns an error message if it
  /// couldn't be removed (e.g. it's the only question left), or `null`
  /// on success.
  String? deleteQuestion(int index) {
    if (_questions.length == 1) {
      return 'At least one question is required';
    }
    _questions[index].dispose();
    _questions.removeAt(index);
    if (_currentIndex >= _questions.length) {
      _currentIndex = _questions.length - 1;
    } else if (_currentIndex > index) {
      _currentIndex--;
    }
    notifyListeners();
    return null;
  }

  // ---------------- Options (act on the current question) ----------------

  String? addOption() {
    if (currentQuestion.options.length >= maxOptions) {
      return 'Maximum of $maxOptions options reached';
    }
    currentQuestion.options.add(TeacherQuizOptionDraft());
    notifyListeners();
    return null;
  }

  void removeOption(int optionIndex) {
    final question = currentQuestion;
    question.options[optionIndex].dispose();
    question.options.removeAt(optionIndex);
    if (question.correctIndex == optionIndex) {
      question.correctIndex = -1;
    } else if (question.correctIndex > optionIndex) {
      question.correctIndex--;
    }
    notifyListeners();
  }

  void setCorrectOption(int optionIndex) {
    final question = currentQuestion;
    question.correctIndex = question.correctIndex == optionIndex
        ? -1
        : optionIndex;
    notifyListeners();
  }

  // ---------------- Upload ----------------

  TeacherQuizUploadModel _buildModel() {
    return TeacherQuizUploadModel(
      quizName: quizName,
      gradeId: gradeId,
      classId: classId,
      quizStartAt: quizStartAt,
      dueDate: dueDate,
      questions: _questions.map((q) => q.toModel()).toList(),
    );
  }

  /// Validates and uploads the quiz.
  /// Returns `null` on success, or an error message on failure
  /// (either a validation error or an upload exception).
  Future<String?> upload() async {
    final model = _buildModel();
    final validationError = model.validate();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return validationError;
    }

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _remoteDataSource.upload(model);
      _isUploading = false;
      notifyListeners();
      return null;
    } on TeacherQuizUploadException catch (e) {
      _isUploading = false;
      _errorMessage = e.message;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isUploading = false;
      _errorMessage = 'Error saving Quiz: $e';
      notifyListeners();
      return _errorMessage;
    }
  }

  @override
  void dispose() {
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }
}
