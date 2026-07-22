class ParentPastQuizModel {
  final int id;
  final String topic;
  final int numberOfQuestions;
  final DateTime quizStartAt;
  final DateTime dueDate;
  final TeacherModel teacher;
  final SubjectModel subject;
  final List<QuizSubmissionModel> submissions;

  const ParentPastQuizModel({
    required this.id,
    required this.topic,
    required this.numberOfQuestions,
    required this.quizStartAt,
    required this.dueDate,
    required this.teacher,
    required this.subject,
    required this.submissions,
  });

  factory ParentPastQuizModel.fromMap(Map<String, dynamic> map) {
    return ParentPastQuizModel(
      id: map['id'] as int,
      topic: map['topic'] as String,
      numberOfQuestions: map['number_of_questions'] as int,
      quizStartAt: DateTime.parse(map['quiz_start_at'] as String),
      dueDate: DateTime.parse(map['due_date'] as String),
      teacher: TeacherModel.fromMap(map['teacher_id']),
      subject: SubjectModel.fromMap(map['subject_id']),
      submissions: (map['quiz_student_submissions'] as List<dynamic>)
          .map((e) => QuizSubmissionModel.fromMap(e))
          .toList(),
    );
  }

  bool get isSubmitted => submissions.isNotEmpty;

  QuizSubmissionModel? get submission =>
      submissions.isEmpty ? null : submissions.first;

  @override
  String toString() {
    return 'ParentPastQuizModel('
        'id: $id, '
        'topic: $topic, '
        'numberOfQuestions: $numberOfQuestions, '
        'quizStartAt: $quizStartAt, '
        'dueDate: $dueDate, '
        'teacher: $teacher, '
        'subject: $subject, '
        'submissions: $submissions'
        ')';
  }
}

class QuizSubmissionModel {
  final int id;
  final DateTime createdAt;
  final int totalNumberOfQuestions;
  final int numberOfCorrectQuestions;

  const QuizSubmissionModel({
    required this.id,
    required this.createdAt,
    required this.totalNumberOfQuestions,
    required this.numberOfCorrectQuestions,
  });

  factory QuizSubmissionModel.fromMap(Map<String, dynamic> map) {
    return QuizSubmissionModel(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      totalNumberOfQuestions: map['total_number_of_questions'] as int,
      numberOfCorrectQuestions: map['number_of_correct_questions'] as int,
    );
  }

  @override
  String toString() {
    return 'QuizSubmissionModel('
        'id: $id, '
        'createdAt: $createdAt, '
        'totalNumberOfQuestions: $totalNumberOfQuestions, '
        'numberOfCorrectQuestions: $numberOfCorrectQuestions'
        ')';
  }
}

class TeacherModel {
  final String name;

  const TeacherModel({required this.name});

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(name: map['name'] as String);
  }

  @override
  String toString() => 'TeacherModel(name: $name)';
}

class SubjectModel {
  final String name;

  const SubjectModel({required this.name});

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(name: map['name'] as String);
  }

  @override
  String toString() => 'SubjectModel(name: $name)';
}
