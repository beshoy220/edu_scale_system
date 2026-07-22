class TeacherUserModel {
  final String id;
  final String name;
  final String email;
  final String status;
  final String? phone;
  final String? subjectName;

  TeacherUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.status = 'pending',
    this.phone,
    this.subjectName,
  });

  factory TeacherUserModel.fromJson(Map<String, dynamic> json) {
    return TeacherUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      status: json['status'],
      subjectName: json['user_profiles']['subject_id']['name'] ?? '',
    );
  }
}
