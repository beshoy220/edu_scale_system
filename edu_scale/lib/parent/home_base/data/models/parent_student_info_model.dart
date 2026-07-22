class ParentStudentInfoModel {
  final String id;
  final int schoolId;
  final String role;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final String status;
  final String? gender;
  final DateTime? birthday;
  final DateTime createdAt;

  const ParentStudentInfoModel({
    required this.id,
    required this.schoolId,
    required this.role,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
    required this.status,
    this.gender,
    this.birthday,
    required this.createdAt,
  });

  factory ParentStudentInfoModel.fromJson(Map<String, dynamic> json) {
    return ParentStudentInfoModel(
      id: json['id'] as String,
      schoolId: json['school_id'] as int,
      role: json['role'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'role': role,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'phone': phone,
      'status': status,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
