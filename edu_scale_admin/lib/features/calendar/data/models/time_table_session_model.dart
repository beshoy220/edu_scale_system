class TimeTableSessionModel {
  final int id;
  final int gradeId;
  final int classId;
  final int subjectId;
  final String teacherId;
  final int dayOfWeek;
  final String startAt;
  final String endAt;
  final String? room;
  final String? teacherName;
  final String? subjectName;

  TimeTableSessionModel({
    required this.id,
    required this.gradeId,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startAt,
    required this.endAt,
    required this.room,
    required this.teacherName,
    required this.subjectName,
  });

  factory TimeTableSessionModel.fromJson(Map<String, dynamic> json) {
    return TimeTableSessionModel(
      id: json['id'],
      gradeId: json['grade_id'],
      classId: json['class_id'],
      subjectId: json['subject_id'],
      teacherId: json['teacher_id'],
      dayOfWeek: json['day_of_week'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      room: json['room'],
      teacherName: json['users']?['name'],
      subjectName: json['subjects']?['name'],
    );
  }

  @override
  String toString() {
    return '''
TimeTableSessionModel(
  id: $id,
  gradeId: $gradeId,
  classId: $classId,
  subjectId: $subjectId,
  teacherId: $teacherId,
  dayOfWeek: $dayOfWeek,
  startAt: $startAt,
  endAt: $endAt,
  room: $room,
  teacherName: $teacherName,
  subjectName: $subjectName
)
''';
  }
}
