class ClassForStudentsModel {
  final int id;
  final String name;
  final String nickname;
  final GradeForStudentsModel? grade;

  ClassForStudentsModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.grade,
  });

  factory ClassForStudentsModel.fromJson(Map<String, dynamic> json) {
    return ClassForStudentsModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      grade: json['grades'] != null
          ? GradeForStudentsModel.fromJson(json['grades'])
          : null,
    );
  }

  @override
  String toString() =>
      'ClassForStudentsModel(id: $id, name: $name, nickname: $nickname, grade: ${grade?.name})';
}

class GradeForStudentsModel {
  final int id;
  final String name;

  GradeForStudentsModel({required this.id, required this.name});

  factory GradeForStudentsModel.fromJson(Map<String, dynamic> json) {
    return GradeForStudentsModel(id: json['id'], name: json['name']);
  }

  void operator +(String other) {}
}
