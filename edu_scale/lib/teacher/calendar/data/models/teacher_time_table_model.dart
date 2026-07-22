class TeacherTimeTableModel {
  final int id;
  final TeacherTimeTableGradeModel grade;
  final TeacherTimeTableClassModel classroom;
  final int subjectId;
  final int dayOfWeek;
  final String startAt;
  final String endAt;
  final String? room;
  final DateTime createdAt;

  const TeacherTimeTableModel({
    required this.id,
    required this.grade,
    required this.classroom,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startAt,
    required this.endAt,
    this.room,
    required this.createdAt,
  });

  factory TeacherTimeTableModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimeTableModel(
      id: json['id'] as int,
      grade: TeacherTimeTableGradeModel.fromJson(
        json['grade'] as Map<String, dynamic>,
      ),
      classroom: TeacherTimeTableClassModel.fromJson(
        json['class'] as Map<String, dynamic>,
      ),
      subjectId: json['subject_id'] as int,
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
      'grade': grade.toJson(),
      'class': classroom.toJson(),
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_at': startAt,
      'end_at': endAt,
      'room': room,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TeacherTimeTableModel copyWith({
    int? id,
    int? schoolId,
    TeacherTimeTableGradeModel? grade,
    TeacherTimeTableClassModel? classroom,
    int? subjectId,
    String? teacherId,
    int? dayOfWeek,
    String? startAt,
    String? endAt,
    String? room,
    DateTime? createdAt,
  }) {
    return TeacherTimeTableModel(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      classroom: classroom ?? this.classroom,
      subjectId: subjectId ?? this.subjectId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'TeacherTimeTableModel(id: $id, grade: $grade, classroom: $classroom, subjectId: $subjectId, dayOfWeek: $dayOfWeek, startAt: $startAt, endAt: $endAt, room: $room, createdAt: $createdAt)';
  }
}

class TeacherTimeTableGradeModel {
  final int id;
  final String name;

  const TeacherTimeTableGradeModel({required this.id, required this.name});

  factory TeacherTimeTableGradeModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimeTableGradeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  TeacherTimeTableGradeModel copyWith({int? id, String? name}) {
    return TeacherTimeTableGradeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'TeacherTimeTableGradeModel(id: $id, name: $name)';
  }
}

class TeacherTimeTableClassModel {
  final int id;
  final String nickname;

  const TeacherTimeTableClassModel({required this.id, required this.nickname});

  factory TeacherTimeTableClassModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimeTableClassModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'nickname': nickname};

  TeacherTimeTableClassModel copyWith({int? id, String? nickname}) {
    return TeacherTimeTableClassModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  String toString() {
    return 'TeacherTimeTableClassModel(id: $id, nickname: $nickname)';
  }
}
