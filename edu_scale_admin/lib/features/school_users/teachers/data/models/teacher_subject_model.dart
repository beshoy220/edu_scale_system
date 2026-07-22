class TeacherSubjectModel {
  final int id;
  final String name;

  TeacherSubjectModel({required this.id, required this.name});

  factory TeacherSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
