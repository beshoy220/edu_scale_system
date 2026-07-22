class ClassForParentsModel {
  final int id;
  final String name;
  final String nickname;
  final GradeForParentsModel? grade;

  ClassForParentsModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.grade,
  });

  factory ClassForParentsModel.fromJson(Map<String, dynamic> json) {
    return ClassForParentsModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      grade: json['grades'] != null
          ? GradeForParentsModel.fromJson(json['grades'])
          : null,
    );
  }

  @override
  String toString() =>
      'ClassForParentsModel(id: $id, name: $name, nickname: $nickname, grade: ${grade?.name})';
}

class GradeForParentsModel {
  final int id;
  final String name;

  GradeForParentsModel({required this.id, required this.name});

  factory GradeForParentsModel.fromJson(Map<String, dynamic> json) {
    return GradeForParentsModel(id: json['id'], name: json['name']);
  }

  void operator +(String other) {}
}
