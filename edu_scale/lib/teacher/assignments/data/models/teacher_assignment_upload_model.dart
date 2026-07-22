/// Pure data models used to build the payload for a new assignment.
///
/// These models hold no UI state (no TextEditingControllers) — they're
/// meant to be built right before uploading, from whatever editing state
/// the presentation layer (the provider) keeps.
class TeacherAssignmentUploadModel {
  final String assignmentName;
  final int gradeId;
  final int? classId; // null = whole grade
  final DateTime dueDate;
  final List<TeacherAssignmentUploadQuestionModel> questions;

  const TeacherAssignmentUploadModel({
    required this.assignmentName,
    required this.gradeId,
    required this.dueDate,
    required this.questions,
    this.classId,
  });

  /// Validates the whole assignment before it gets uploaded.
  /// Returns a human readable error message, or `null` if everything
  /// is valid.
  String? validate() {
    if (assignmentName.trim().isEmpty) {
      return 'Assignment name is empty.';
    }
    if (questions.isEmpty) {
      return 'At least one question is required.';
    }
    for (var i = 0; i < questions.length; i++) {
      final error = questions[i].validate();
      if (error != null) {
        return 'Question ${i + 1} is invalid.\nReason: $error';
      }
    }
    return null;
  }

  bool get isValid => validate() == null;

  /// JSON body for the `assignments` table.
  ///
  /// `teacherId`, `schoolId` and `subjectId` are only known by the data
  /// source (they come from the cached account), so they're passed in
  /// here instead of being stored on the model itself.
  Map<String, dynamic> toAssignmentJson({
    required int schoolId,
    required String teacherId,
    required int subjectId,
  }) {
    return {
      'school_id': schoolId,
      'teacher_id': teacherId,
      'subject_id': subjectId,
      'grade_id': gradeId,
      'class_id': classId,
      'topic': assignmentName,
      'publish_status': 'published',
      'due_date': dueDate.toIso8601String(),
      'number_of_questions': questions.length,
    };
  }

  /// JSON bodies for the `assignment_questions` table rows.
  /// Needs the generated `assignmentId` returned by the assignment insert.
  List<Map<String, dynamic>> toQuestionsJson({
    required int assignmentId,
    required int schoolId,
  }) {
    return List.generate(questions.length, (i) {
      return questions[i].toJson(
        assignmentId: assignmentId,
        schoolId: schoolId,
        questionOrder: i + 1,
      );
    });
  }

  TeacherAssignmentUploadModel copyWith({
    String? assignmentName,
    int? gradeId,
    int? classId,
    DateTime? dueDate,
    List<TeacherAssignmentUploadQuestionModel>? questions,
  }) {
    return TeacherAssignmentUploadModel(
      assignmentName: assignmentName ?? this.assignmentName,
      gradeId: gradeId ?? this.gradeId,
      classId: classId ?? this.classId,
      dueDate: dueDate ?? this.dueDate,
      questions: questions ?? this.questions,
    );
  }
}

class TeacherAssignmentUploadQuestionModel {
  static const int minOptions = 2;
  static const int maxOptions = 6;

  final String questionText;
  final List<String> options;
  final int correctIndex; // -1 = none selected

  const TeacherAssignmentUploadQuestionModel({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });

  String? get modelAnswer =>
      (correctIndex >= 0 && correctIndex < options.length)
          ? options[correctIndex]
          : null;

  /// Validates a single question.
  /// Returns an error message, or `null` if the question is valid.
  String? validate() {
    if (questionText.trim().isEmpty) {
      return 'Question title is empty.';
    }

    final nonEmptyOptions =
        options.where((o) => o.trim().isNotEmpty).toList();
    if (nonEmptyOptions.length < minOptions) {
      return 'At least $minOptions options are required.';
    }

    for (var i = 0; i < options.length; i++) {
      if (options[i].trim().isEmpty) {
        return 'Option ${String.fromCharCode(65 + i)} is empty.';
      }
    }

    if (correctIndex == -1) {
      return 'No correct answer selected.';
    }

    if (modelAnswer == null || modelAnswer!.trim().isEmpty) {
      return 'Selected correct answer is empty.';
    }

    final lowerCaseOptions =
        options.map((o) => o.trim().toLowerCase()).toList();
    if (lowerCaseOptions.toSet().length != lowerCaseOptions.length) {
      return 'Options must be different.';
    }

    return null;
  }

  bool get isValid => validate() == null;

  /// Maps to the six `options_x` columns in the `assignment_questions`
  /// table.
  Map<String, dynamic> toJson({
    required int assignmentId,
    required int schoolId,
    required int questionOrder,
  }) {
    final paddedOptions = List<String?>.filled(maxOptions, null);
    for (var i = 0; i < options.length && i < maxOptions; i++) {
      paddedOptions[i] = options[i];
    }

    return {
      'school_id': schoolId,
      'assignment_id': assignmentId,
      'question_order': questionOrder,
      'question_text': questionText,
      'options_1': paddedOptions[0],
      'options_2': paddedOptions[1],
      'options_3': paddedOptions[2],
      'options_4': paddedOptions[3],
      'options_5': paddedOptions[4],
      'options_6': paddedOptions[5],
      'model_answer': modelAnswer,
    };
  }

  TeacherAssignmentUploadQuestionModel copyWith({
    String? questionText,
    List<String>? options,
    int? correctIndex,
  }) {
    return TeacherAssignmentUploadQuestionModel(
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
    );
  }
}
