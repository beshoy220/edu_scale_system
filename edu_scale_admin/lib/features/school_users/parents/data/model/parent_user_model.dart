class ParentUserModel {
  final String name;
  final String email;
  final String phone;
  final String status;
  final String classNickname;
  final StudentModel student;

  ParentUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.classNickname,
    required this.student,
  });

  factory ParentUserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['user_profiles'] as Map<String, dynamic>? ?? {};
    return ParentUserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      classNickname: profile['class_id']?['nickname'] ?? '',
      student: StudentModel.fromJson(profile['student_id'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'classNickname': classNickname,
      'student': student.toJson(),
    };
  }

  @override
  String toString() =>
      'ParentUserModel(name: $name, email: $email, phone: $phone, status: $status, classNickname: $classNickname, student: ${student.toJson()})';
}

class StudentModel {
  final String name;

  StudentModel({required this.name});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  String toString() => 'StudentModel(name: $name)';
}
