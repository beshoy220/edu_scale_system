class TeacherAssignmentQuestionModel {
  final String questionText;
  final List<String> options;
  final String modelAnswer;

  const TeacherAssignmentQuestionModel({
    required this.questionText,
    required this.options,
    required this.modelAnswer,
  });

  factory TeacherAssignmentQuestionModel.fromMap(Map<String, dynamic> json) {
    final options = <String>[
      json['options_1'],
      json['options_2'],
      json['options_3'] ?? '',
      json['options_4'] ?? '',
      json['options_5'] ?? '',
      json['options_6'] ?? '',
    ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();

    return TeacherAssignmentQuestionModel(
      questionText: json['question_text'] as String,
      options: options,
      modelAnswer: json['model_answer'] as String,
    );
  }

  TeacherAssignmentQuestionModel copyWith({
    String? questionText,
    List<String>? options,
    String? modelAnswer,
  }) {
    return TeacherAssignmentQuestionModel(
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      modelAnswer: modelAnswer ?? this.modelAnswer,
    );
  }

  @override
  String toString() {
    return 'TeacherAssignmentQuestionModel('
        'questionText: $questionText, '
        'options: $options, '
        'modelAnswer: $modelAnswer'
        ')';
  }
}
