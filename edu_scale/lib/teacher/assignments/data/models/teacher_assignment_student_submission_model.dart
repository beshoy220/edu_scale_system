class TeacherAssignmentStudentSubmissionModel {
  final String studentName;
  final int numberOfCorrectQuestions;
  final int totalNumberOfQuestions;

  const TeacherAssignmentStudentSubmissionModel({
    required this.studentName,
    required this.numberOfCorrectQuestions,
    required this.totalNumberOfQuestions,
  });

  factory TeacherAssignmentStudentSubmissionModel.fromMap(
    Map<String, dynamic> json,
  ) {
    return TeacherAssignmentStudentSubmissionModel(
      studentName: json['users']['name'] as String,
      numberOfCorrectQuestions: json['number_of_correct_questions'] as int,
      totalNumberOfQuestions: json['total_number_of_questions'] as int,
    );
  }

  TeacherAssignmentStudentSubmissionModel copyWith({
    String? studentName,
    int? numberOfCorrectQuestions,
    int? totalNumberOfQuestions,
  }) {
    return TeacherAssignmentStudentSubmissionModel(
      studentName: studentName ?? this.studentName,
      numberOfCorrectQuestions:
          numberOfCorrectQuestions ?? this.numberOfCorrectQuestions,
      totalNumberOfQuestions:
          totalNumberOfQuestions ?? this.totalNumberOfQuestions,
    );
  }

  @override
  String toString() {
    return 'TeacherAssignmentStudentSubmissionModel('
        'studentName: $studentName, '
        'numberOfCorrectQuestions: $numberOfCorrectQuestions, '
        'totalNumberOfQuestions: $totalNumberOfQuestions'
        ')';
  }
}
