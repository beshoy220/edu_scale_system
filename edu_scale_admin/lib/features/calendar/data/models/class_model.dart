import 'grade_model.dart';

class ClassModel {
  final int id;
  final String name;
  final String nickname;
  final GradeModel? grade;

  ClassModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.grade,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      grade: json['grades'] != null
          ? GradeModel.fromJson(json['grades'])
          : null,
    );
  }

  @override
  String toString() =>
      'ClassModel(id: $id, name: $name, nickname: $nickname, grade: ${grade?.name})';
}
