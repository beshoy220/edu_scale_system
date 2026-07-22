class TeacherAttendanceClassesListModel {
  final int classId;
  final String classNickname;
  final int gradeId;
  final String gradeName;

  const TeacherAttendanceClassesListModel({
    required this.classId,
    required this.classNickname,
    required this.gradeId,
    required this.gradeName,
  });

  factory TeacherAttendanceClassesListModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAttendanceClassesListModel(
      classId: json['id'],
      classNickname: json['nickname'],
      gradeId: json['grade_id'],
      gradeName: json['grades']['name'],
    );
  }
}
