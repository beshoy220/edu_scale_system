class TeacherModel {
  final String id;
  final String name;
  final String email;
  final int? subjectId;
  final String? subjectName;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subjectId,
    required this.subjectName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final profile = json['user_profiles'];
    final subject = profile?['subjects'];

    return TeacherModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      subjectId: profile?['subject_id'],
      subjectName: subject?['name'],
    );
  }

  @override
  String toString() {
    return 'TeacherModel(id: $id, name: $name, subjectId: $subjectId, subject: $subjectName)';
  }
}
