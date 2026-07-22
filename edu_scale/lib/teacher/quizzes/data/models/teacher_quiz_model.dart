class TeacherQuizModel {
  final int quizId;
  final String quizName;

  final int gradeId;
  final String gradeName;

  final int? classId;
  final String? classNickname;

  final DateTime quizStartAt;
  final DateTime dueDate;
  final String publishStatus;

  final DateTime createdAt;

  final int questionsCount;

  TeacherQuizModel({
    required this.quizId,
    required this.quizName,
    required this.gradeId,
    required this.gradeName,
    required this.classId,
    required this.classNickname,
    required this.quizStartAt,
    required this.dueDate,
    required this.publishStatus,
    required this.createdAt,
    required this.questionsCount,
  });

  factory TeacherQuizModel.fromMap(Map<String, dynamic> json) {
    return TeacherQuizModel(
      quizId: json['id'],
      quizName: json['topic'],

      gradeId: json['grades']['id'],
      gradeName: json['grades']['name'],

      classId: json['classes']?['id'],
      classNickname: json['classes']?['nickname'],

      quizStartAt: DateTime.parse(json['quiz_start_at']),
      dueDate: DateTime.parse(json['due_date']),
      publishStatus: json['publish_status'],

      createdAt: DateTime.parse(json['created_at']),

      questionsCount: json['number_of_questions'],
    );
  }

  TeacherQuizModel copyWith({
    int? quizId,
    String? quizName,
    int? gradeId,
    String? gradeName,
    int? classId,
    String? classNickname,
    DateTime? quizStartAt,
    DateTime? dueDate,
    String? publishStatus,
    DateTime? createdAt,
    int? questionsCount,
  }) {
    return TeacherQuizModel(
      quizId: quizId ?? this.quizId,
      quizName: quizName ?? this.quizName,
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      classId: classId ?? this.classId,
      classNickname: classNickname ?? this.classNickname,
      quizStartAt: quizStartAt ?? this.quizStartAt,
      dueDate: dueDate ?? this.dueDate,
      publishStatus: publishStatus ?? this.publishStatus,
      createdAt: createdAt ?? this.createdAt,
      questionsCount: questionsCount ?? this.questionsCount,
    );
  }

  @override
  String toString() {
    return 'TeacherQuizModel(QuizId: $quizId, QuizName: $quizName, gradeId: $gradeId, gradeName: $gradeName, classId: $classId, classNickname: $classNickname, quizStartAt: $quizStartAt, dueDate: $dueDate, publishStatus: $publishStatus, questionsCount: $questionsCount)';
  }
}
