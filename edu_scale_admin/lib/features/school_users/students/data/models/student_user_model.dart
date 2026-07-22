class StudentUserModel {
  final String name;
  final String email;
  final String status;
  final String classNickname;
  final ParentModel parent;

  StudentUserModel({
    required this.name,
    required this.email,
    required this.status,
    required this.classNickname,
    required this.parent,
  });

  factory StudentUserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['user_profiles'] as Map<String, dynamic>? ?? {};
    return StudentUserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      classNickname: profile['class_id']?['nickname'] ?? '',
      parent: ParentModel.fromJson(profile['parent_id'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'status': status,
      'classNickname': classNickname,
      'parent': parent.toJson(),
    };
  }

  @override
  String toString() =>
      'StudentUserModel(name: $name, email: $email, status: $status, classNickname: $classNickname, parent: ${parent.toJson()})';
}

class ParentModel {
  final String name;
  final String phone;

  ParentModel({required this.name, required this.phone});

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(name: json['name'] ?? '', phone: json['phone'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }

  @override
  String toString() => 'ParentModel(name: $name, phone: $phone)';
}
