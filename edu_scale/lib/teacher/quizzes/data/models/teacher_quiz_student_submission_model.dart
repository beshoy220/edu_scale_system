class TeacherQuizStudentSubmissionModel {
  final String studentName;
  final int numberOfCorrectQuestions;
  final int totalNumberOfQuestions;

  const TeacherQuizStudentSubmissionModel({
    required this.studentName,
    required this.numberOfCorrectQuestions,
    required this.totalNumberOfQuestions,
  });

  factory TeacherQuizStudentSubmissionModel.fromMap(Map<String, dynamic> json) {
    return TeacherQuizStudentSubmissionModel(
      studentName: json['users']['name'] as String,
      numberOfCorrectQuestions: json['number_of_correct_questions'] as int,
      totalNumberOfQuestions: json['total_number_of_questions'] as int,
    );
  }

  TeacherQuizStudentSubmissionModel copyWith({
    String? studentName,
    int? numberOfCorrectQuestions,
    int? totalNumberOfQuestions,
  }) {
    return TeacherQuizStudentSubmissionModel(
      studentName: studentName ?? this.studentName,
      numberOfCorrectQuestions:
          numberOfCorrectQuestions ?? this.numberOfCorrectQuestions,
      totalNumberOfQuestions:
          totalNumberOfQuestions ?? this.totalNumberOfQuestions,
    );
  }

  @override
  String toString() {
    return 'TeacherQuizStudentSubmissionModel('
        'studentName: $studentName, '
        'numberOfCorrectQuestions: $numberOfCorrectQuestions, '
        'totalNumberOfQuestions: $totalNumberOfQuestions'
        ')';
  }
}
