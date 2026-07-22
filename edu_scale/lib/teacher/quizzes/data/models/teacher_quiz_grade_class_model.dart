class TeacherQuizGradeClassModel {
  final int gradeId;
  final String gradeName;

  /// Null means the quiz is for the whole grade.
  final int? classId;
  final String? className;

  const TeacherQuizGradeClassModel({
    required this.gradeId,
    required this.gradeName,
    required this.classId,
    required this.className,
  });

  factory TeacherQuizGradeClassModel.fromMap(Map<String, dynamic> json) {
    return TeacherQuizGradeClassModel(
      gradeId: json['grade_id'] as int,
      gradeName: json['grade_name'] as String,
      classId: json['class_id'] as int?,
      className: json['class_name'] as String?,
    );
  }

  TeacherQuizGradeClassModel copyWith({
    int? gradeId,
    String? gradeName,
    int? classId,
    String? className,
  }) {
    return TeacherQuizGradeClassModel(
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
    );
  }

  @override
  String toString() {
    return 'TeacherQuizGradeClassModel('
        'gradeId: $gradeId, '
        'gradeName: $gradeName, '
        'classId: $classId, '
        'className: $className'
        ')';
  }
}
