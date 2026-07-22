class TeacherAssignmentGradeClassModel {
  final int gradeId;
  final String gradeName;

  /// Null means the assignment is for the whole grade.
  final int? classId;
  final String? className;

  const TeacherAssignmentGradeClassModel({
    required this.gradeId,
    required this.gradeName,
    required this.classId,
    required this.className,
  });

  factory TeacherAssignmentGradeClassModel.fromMap(Map<String, dynamic> json) {
    return TeacherAssignmentGradeClassModel(
      gradeId: json['grade_id'] as int,
      gradeName: json['grade_name'] as String,
      classId: json['class_id'] as int?,
      className: json['class_name'] as String?,
    );
  }

  TeacherAssignmentGradeClassModel copyWith({
    int? gradeId,
    String? gradeName,
    int? classId,
    String? className,
  }) {
    return TeacherAssignmentGradeClassModel(
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
    );
  }

  @override
  String toString() {
    return 'TeacherAssignmentGradeClassModel('
        'gradeId: $gradeId, '
        'gradeName: $gradeName, '
        'classId: $classId, '
        'className: $className'
        ')';
  }
}
