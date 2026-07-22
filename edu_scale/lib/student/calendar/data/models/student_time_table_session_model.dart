class StudentTimetableSessionModel {
  final int id;
  final String subject;
  final String teacher;
  final int dayOfWeek;
  final String startAt;
  final String endAt;
  final String? room;
  final DateTime createdAt;

  const StudentTimetableSessionModel({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.dayOfWeek,
    required this.startAt,
    required this.endAt,
    this.room,
    required this.createdAt,
  });

  factory StudentTimetableSessionModel.fromJson(Map<String, dynamic> json) {
    return StudentTimetableSessionModel(
      id: json['id'] as int,
      subject: (json['subject'] as Map<String, dynamic>)['name'] as String,
      teacher: (json['teacher'] as Map<String, dynamic>)['name'] as String,
      dayOfWeek: json['day_of_week'] as int,
      startAt: json['start_at'] as String,
      endAt: json['end_at'] as String,
      room: json['room'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': {'name': subject},
      'teacher': {'name': teacher},
      'day_of_week': dayOfWeek,
      'start_at': startAt,
      'end_at': endAt,
      'room': room,
      'created_at': createdAt.toIso8601String(),
    };
  }

  StudentTimetableSessionModel copyWith({
    int? id,
    String? subject,
    String? teacher,
    int? dayOfWeek,
    String? startAt,
    String? endAt,
    String? room,
    DateTime? createdAt,
  }) {
    return StudentTimetableSessionModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'StudentTimetableSessionModel('
        'id: $id, '
        'subject: $subject, '
        'teacher: $teacher, '
        'dayOfWeek: $dayOfWeek, '
        'startAt: $startAt, '
        'endAt: $endAt, '
        'room: $room, '
        'createdAt: $createdAt'
        ')';
  }
}
