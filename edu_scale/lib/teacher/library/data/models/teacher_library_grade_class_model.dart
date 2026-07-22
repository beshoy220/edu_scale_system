class TeacherLibraryGradeClassModel {
  final int gradeId;
  final String gradeName;

  /// Null means the assignment is for the whole grade.
  final int? classId;
  final String? className;

  const TeacherLibraryGradeClassModel({
    required this.gradeId,
    required this.gradeName,
    required this.classId,
    required this.className,
  });

  factory TeacherLibraryGradeClassModel.fromMap(Map<String, dynamic> json) {
    return TeacherLibraryGradeClassModel(
      gradeId: json['grade_id'] as int,
      gradeName: json['grade_name'] as String,
      classId: json['class_id'] as int?,
      className: json['class_name'] as String?,
    );
  }

  TeacherLibraryGradeClassModel copyWith({
    int? gradeId,
    String? gradeName,
    int? classId,
    String? className,
  }) {
    return TeacherLibraryGradeClassModel(
      gradeId: gradeId ?? this.gradeId,
      gradeName: gradeName ?? this.gradeName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
    );
  }

  @override
  String toString() {
    return 'TeacherLibraryGradeClassModel('
        'gradeId: $gradeId, '
        'gradeName: $gradeName, '
        'classId: $classId, '
        'className: $className'
        ')';
  }
}
