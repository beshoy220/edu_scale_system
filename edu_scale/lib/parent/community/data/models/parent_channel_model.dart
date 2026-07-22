class ParentChannelModel {
  final int id;
  final int schoolId;
  final ParentGradeChannelModel? grade;
  final ParentClassChannelModel? classroom;

  const ParentChannelModel({
    required this.id,
    required this.schoolId,
    this.grade,
    this.classroom,
  });

  factory ParentChannelModel.fromJson(Map<String, dynamic> json) {
    return ParentChannelModel(
      id: json['id'] as int,
      schoolId: json['school_id'] as int,
      grade: json['grade_id'] != null
          ? ParentGradeChannelModel.fromJson(
              json['grade_id'] as Map<String, dynamic>,
            )
          : null,
      classroom: json['class_id'] != null
          ? ParentClassChannelModel.fromJson(
              json['class_id'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  String toString() =>
      'ParentChannelModel(id: $id, schoolId: $schoolId, grade: $grade, class: $classroom)';
}

class ParentGradeChannelModel {
  final int id;
  final String name;

  const ParentGradeChannelModel({required this.id, required this.name});

  factory ParentGradeChannelModel.fromJson(Map<String, dynamic> json) {
    return ParentGradeChannelModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
  @override
  String toString() => 'ParentGradeChannelModel(id: $id, grade: $name)';
}

class ParentClassChannelModel {
  final int id;
  final String nickname;

  const ParentClassChannelModel({required this.id, required this.nickname});

  factory ParentClassChannelModel.fromJson(Map<String, dynamic> json) {
    return ParentClassChannelModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
    );
  }

  @override
  String toString() => 'ParentClassChannelModel(id: $id, grade: $nickname)';
}
