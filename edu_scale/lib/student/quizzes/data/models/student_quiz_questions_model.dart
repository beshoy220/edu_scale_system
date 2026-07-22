class StudentQuizQuestionsModel {
  final int id;
  final int quizId;
  final int questionOrder;
  final String questionText;
  final List<String> options;
  final String modelAnswer;

  StudentQuizQuestionsModel({
    required this.id,
    required this.quizId,
    required this.questionOrder,
    required this.questionText,
    required this.options,
    required this.modelAnswer,
  });

  factory StudentQuizQuestionsModel.fromMap(Map<String, dynamic> map) {
    final options = <String>[];
    for (var i = 1; i <= 6; i++) {
      final option = map['options_$i'];
      if (option != null) {
        options.add(option as String);
      }
    }

    return StudentQuizQuestionsModel(
      id: map['id'] as int,
      quizId: map['quiz_id'] as int,
      questionOrder: map['question_order'] as int,
      questionText: map['question_text'] as String,
      options: options,
      modelAnswer: map['model_answer'] as String,
    );
  }

  @override
  String toString() {
    return 'StudentQuizQuestionsModel(id: $id, quizId: $quizId, '
        'questionOrder: $questionOrder, questionText: $questionText, '
        'options: $options, modelAnswer: $modelAnswer)';
  }
}
