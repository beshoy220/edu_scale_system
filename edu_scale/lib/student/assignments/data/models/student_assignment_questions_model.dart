class StudentAssignmentQuestionsModel {
  final int id;
  final int assignmentId;
  final int questionOrder;
  final String questionText;
  final List<String> options;
  final String modelAnswer;

  StudentAssignmentQuestionsModel({
    required this.id,
    required this.assignmentId,
    required this.questionOrder,
    required this.questionText,
    required this.options,
    required this.modelAnswer,
  });

  factory StudentAssignmentQuestionsModel.fromMap(Map<String, dynamic> map) {
    final options = <String>[];
    for (var i = 1; i <= 6; i++) {
      final option = map['options_$i'];
      if (option != null) {
        options.add(option as String);
      }
    }

    return StudentAssignmentQuestionsModel(
      id: map['id'] as int,
      assignmentId: map['assignment_id'] as int,
      questionOrder: map['question_order'] as int,
      questionText: map['question_text'] as String,
      options: options,
      modelAnswer: map['model_answer'] as String,
    );
  }

  @override
  String toString() {
    return 'StudentAssignmentQuestionsModel(id: $id, assignmentId: $assignmentId, '
        'questionOrder: $questionOrder, questionText: $questionText, '
        'options: $options, modelAnswer: $modelAnswer)';
  }
}
