class StudentChannelModel {
  final int id;
  final int schoolId;
  final StudentGradeChannelModel? grade;
  final StudentClassChannelModel? classroom;

  const StudentChannelModel({
    required this.id,
    required this.schoolId,
    this.grade,
    this.classroom,
  });

  factory StudentChannelModel.fromJson(Map<String, dynamic> json) {
    return StudentChannelModel(
      id: json['id'] as int,
      schoolId: json['school_id'] as int,
      grade: json['grade_id'] != null
          ? StudentGradeChannelModel.fromJson(
              json['grade_id'] as Map<String, dynamic>,
            )
          : null,
      classroom: json['class_id'] != null
          ? StudentClassChannelModel.fromJson(
              json['class_id'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  String toString() =>
      'StudentChannelModel(id: $id, schoolId: $schoolId, grade: $grade, class: $classroom)';
}

class StudentGradeChannelModel {
  final int id;
  final String name;

  const StudentGradeChannelModel({required this.id, required this.name});

  factory StudentGradeChannelModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeChannelModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
  @override
  String toString() => 'StudentGradeChannelModel(id: $id, grade: $name)';
}

class StudentClassChannelModel {
  final int id;
  final String nickname;

  const StudentClassChannelModel({required this.id, required this.nickname});

  factory StudentClassChannelModel.fromJson(Map<String, dynamic> json) {
    return StudentClassChannelModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
    );
  }

  @override
  String toString() => 'StudentClassChannelModel(id: $id, grade: $nickname)';
}
