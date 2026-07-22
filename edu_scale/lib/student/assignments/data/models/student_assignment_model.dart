class StudentAssignmentModel {
  final int id;
  final String topic;
  final int numberOfQuestions;
  final DateTime dueDate;

  final String subjectName;
  final String teacherName;

  final StudentAssignmentSubmissionModel? submission;

  const StudentAssignmentModel({
    required this.id,
    required this.topic,
    required this.numberOfQuestions,
    required this.dueDate,
    required this.subjectName,
    required this.teacherName,
    this.submission,
  });

  factory StudentAssignmentModel.fromJson(Map<String, dynamic> json) {
    final submissionList = json['assignment_student_submissions'] as List?;

    return StudentAssignmentModel(
      id: json['id'],
      topic: json['topic'],
      numberOfQuestions: json['number_of_questions'],
      dueDate: DateTime.parse(json['due_date']),
      subjectName: json['subject']['name'],
      teacherName: json['teacher']['name'],
      submission: submissionList != null && submissionList.isNotEmpty
          ? StudentAssignmentSubmissionModel.fromJson(submissionList.first)
          : null,
    );
  }

  @override
  String toString() =>
      'StudentAssignmentModel(id: $id, topic: $topic, numberOfQuestions: $numberOfQuestions, dueDate: $dueDate, subjectName: $subjectName, teacherName: $teacherName, submission: $submission)';
}

class StudentAssignmentSubmissionModel {
  final int id;
  final int numberOfCorrectQuestions;
  final int totalNumberOfQuestions;
  final DateTime createdAt;

  const StudentAssignmentSubmissionModel({
    required this.id,
    required this.numberOfCorrectQuestions,
    required this.totalNumberOfQuestions,
    required this.createdAt,
  });

  factory StudentAssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return StudentAssignmentSubmissionModel(
      id: json['id'],
      numberOfCorrectQuestions: json['number_of_correct_questions'] ?? 0,
      totalNumberOfQuestions: json['total_number_of_questions'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  String toString() =>
      'StudentAssignmentSubmissionModel(id: $id, numberOfCorrectQuestions: $numberOfCorrectQuestions, totalNumberOfQuestions: $totalNumberOfQuestions, createdAt: $createdAt)';
}
