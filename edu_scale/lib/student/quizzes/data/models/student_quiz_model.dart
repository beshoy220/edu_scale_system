class StudentQuizModel {
  final int id;
  final String topic;
  final int numberOfQuestions;
  final DateTime quizStartAt;
  final DateTime dueDate;

  final String subjectName;
  final String teacherName;

  final StudentQuizSubmissionModel? submission;

  const StudentQuizModel({
    required this.id,
    required this.topic,
    required this.numberOfQuestions,
    required this.quizStartAt,
    required this.dueDate,
    required this.subjectName,
    required this.teacherName,
    this.submission,
  });

  factory StudentQuizModel.fromJson(Map<String, dynamic> json) {
    final submissionList = json['quiz_student_submissions'] as List?;

    return StudentQuizModel(
      id: json['id'],
      topic: json['topic'],
      numberOfQuestions: json['number_of_questions'],
      quizStartAt: DateTime.parse(json['quiz_start_at']),
      dueDate: DateTime.parse(json['due_date']),
      subjectName: json['subject']['name'],
      teacherName: json['teacher']['name'],
      submission: submissionList != null && submissionList.isNotEmpty
          ? StudentQuizSubmissionModel.fromJson(submissionList.first)
          : null,
    );
  }

  @override
  String toString() =>
      'StudentQuizModel(id: $id, topic: $topic, numberOfQuestions: $numberOfQuestions,quizStartAt: $quizStartAt, dueDate: $dueDate, subjectName: $subjectName, teacherName: $teacherName, submission: $submission)';
}

class StudentQuizSubmissionModel {
  final int id;
  final int numberOfCorrectQuestions;
  final int totalNumberOfQuestions;
  final DateTime createdAt;

  const StudentQuizSubmissionModel({
    required this.id,
    required this.numberOfCorrectQuestions,
    required this.totalNumberOfQuestions,
    required this.createdAt,
  });

  factory StudentQuizSubmissionModel.fromJson(Map<String, dynamic> json) {
    return StudentQuizSubmissionModel(
      id: json['id'],
      numberOfCorrectQuestions: json['number_of_correct_questions'] ?? 0,
      totalNumberOfQuestions: json['total_number_of_questions'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  String toString() =>
      'StudentQuizSubmissionModel(id: $id, numberOfCorrectQuestions: $numberOfCorrectQuestions, totalNumberOfQuestions: $totalNumberOfQuestions, createdAt: $createdAt)';
}
