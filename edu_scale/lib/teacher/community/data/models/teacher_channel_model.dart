class TeacherChannelModel {
  final int id;
  final int schoolId;
  final TeacherGradeChannelModel? grade;
  final TeacherClassChannelModel? classroom;

  const TeacherChannelModel({
    required this.id,
    required this.schoolId,
    this.grade,
    this.classroom,
  });

  factory TeacherChannelModel.fromJson(Map<String, dynamic> json) {
    return TeacherChannelModel(
      id: json['id'] as int,
      schoolId: json['school_id'] as int,
      grade: json['grade'] != null
          ? TeacherGradeChannelModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,
      classroom: json['class'] != null
          ? TeacherClassChannelModel.fromJson(
              json['class'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'grade': grade?.toJson(),
      'class': classroom?.toJson(),
    };
  }

  TeacherChannelModel copyWith({
    int? id,
    int? schoolId,
    TeacherGradeChannelModel? grade,
    TeacherClassChannelModel? classroom,
  }) {
    return TeacherChannelModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      grade: grade ?? this.grade,
      classroom: classroom ?? this.classroom,
    );
  }

  @override
  String toString() {
    return 'TeacherChannelModel('
        'id: $id, '
        'schoolId: $schoolId, '
        'grade: $grade, '
        'classroom: $classroom'
        ')';
  }
}

class TeacherGradeChannelModel {
  final int id;
  final String name;

  const TeacherGradeChannelModel({required this.id, required this.name});

  factory TeacherGradeChannelModel.fromJson(Map<String, dynamic> json) {
    return TeacherGradeChannelModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  TeacherGradeChannelModel copyWith({int? id, String? name}) {
    return TeacherGradeChannelModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  String toString() {
    return 'TeacherGradeChannelModel(id: $id, name: $name)';
  }
}

class TeacherClassChannelModel {
  final int id;
  final String nickname;

  const TeacherClassChannelModel({required this.id, required this.nickname});

  factory TeacherClassChannelModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassChannelModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nickname': nickname};
  }

  TeacherClassChannelModel copyWith({int? id, String? nickname}) {
    return TeacherClassChannelModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  String toString() {
    return 'TeacherClassChannelModel(id: $id, nickname: $nickname)';
  }
}
