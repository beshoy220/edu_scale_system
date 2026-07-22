class TeacherAssignmentModel {
  final int assignmentId;
  final String assignmentName;

  final int gradeId;
  final String gradeName;

  final int? classId;
  final String? classNickname;

  final DateTime dueDate;
  final String publishStatus;

  final DateTime createdAt;

  final int questionsCount;

  TeacherAssignmentModel({
    required this.assignmentId,
    required this.assignmentName,
    required this.gradeId,
    required this.gradeName,
    required this.classId,
    required this.classNickname,
    required this.dueDate,
    required this.publishStatus,
    required this.createdAt,
    required this.questionsCount,
  });

  factory TeacherAssignmentModel.fromMap(Map<String, dynamic> json) {
    return TeacherAssignmentModel(
      assignmentId: json['id'],
      assignmentName: json['topic'],

      gradeId: json['grades']['id'],
      gradeName: json['grades']['name'],

      classId: json['classes']?['id'],
      classNickname: json['classes']?['nickname'],

      dueDate: DateTime.parse(json['due_date']).toLocal(),
      publishStatus: json['publish_status'],

      createdAt: DateTime.parse(json['created_at']).toLocal(),

      questionsCount: json['number_of_questions'],
    );
  }

  TeacherAssignmentModel copyWith({
    int? assignmentId,
    String? assignmentName,
    int? gradeId,
    String? gradeName,
    int? classId,
    String? classNickname,
    DateTime? dueDate,
    String? publishStatus,
    DateTime? createdAt,
    int? questionsCount,
  }) {
    return TeacherAssignmentModel(
      assignmentId: assignmentId ?? this.assignmentId,
      assignmentName: assignmentName ?? this.assignmentName,
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      classId: classId ?? this.classId,
      classNickname: classNickname ?? this.classNickname,
      dueDate: dueDate ?? this.dueDate,
      publishStatus: publishStatus ?? this.publishStatus,
      createdAt: createdAt ?? this.createdAt,
      questionsCount: questionsCount ?? this.questionsCount,
    );
  }

  @override
  String toString() {
    return 'TeacherAssignmentModel(assignmentId: $assignmentId, assignmentName: $assignmentName, gradeId: $gradeId, gradeName: $gradeName, classId: $classId, classNickname: $classNickname, dueDate: $dueDate, publishStatus: $publishStatus, questionsCount: $questionsCount)';
  }
}
