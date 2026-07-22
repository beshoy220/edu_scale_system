import 'dart:convert';

class CachedAccount {
  final String id;
  final String role;
  final String displayName;
  final String email;
  final String password;
  final String? avatarUrl;
  final String? phone;
  final String? gender;
  final DateTime? birthday;
  final DateTime lastSignIn;

  final int schoolId;

  /// All related IDs are grouped here.
  final UserIds ids;

  const CachedAccount({
    required this.id,
    required this.schoolId,
    required this.role,
    required this.displayName,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.phone,
    this.gender,
    this.birthday,
    required this.lastSignIn,
    required this.ids,
  });

  factory CachedAccount.fromMap(Map<String, dynamic> map) {
    return CachedAccount(
      id: map['id'],
      role: map['role'],
      displayName: map['displayName'],
      email: map['email'],
      password: map['paassword'],
      avatarUrl: map['avatar_url'],
      phone: map['phone'],
      gender: map['gender'],
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'])
          : null,
      lastSignIn: map['lastSignIn'] != null
          ? DateTime.parse(map['lastSignIn'])
          : DateTime.now(),
      schoolId: map['school_id'],
      ids: UserIds.fromMap(map['ids'] ?? map['user_profiles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'displayName': displayName,
      'email': email,
      'password': password,
      'avatar_url': avatarUrl,
      'phone': phone,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'lastSignIn': lastSignIn.toIso8601String(),
      'school_id': schoolId,
      'ids': ids.toJson(),
    };
  }

  factory CachedAccount.fromJson(Map<String, dynamic> json) {
    return CachedAccount(
      id: json['id'],
      role: json['role'],
      displayName: json['displayName'],
      email: json['email'],
      password: json['password'] ?? '',
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      lastSignIn: DateTime.parse(json['lastSignIn']),
      schoolId: json['school_id'],
      ids: UserIds.fromMap(json['ids']),
    );
  }

  CachedAccount copyWithPassword(String newPassword) {
    return CachedAccount(
      id: id,
      role: role,
      displayName: displayName,
      email: email,
      avatarUrl: avatarUrl,
      phone: phone,
      gender: gender,
      birthday: birthday,
      lastSignIn: lastSignIn,
      schoolId: schoolId,
      ids: ids,
      password: newPassword,
    );
  }

  /// Encodes WITHOUT the password - used for the shared_preferences list.
  /// The password is stored separately in flutter_secure_storage.
  String encodeWithoutPassword() {
    final json = toJson();
    json.remove('password');
    return jsonEncode(json);
  }

  String encode() => jsonEncode(toJson());
  factory CachedAccount.decode(String source) {
    return CachedAccount.fromJson(jsonDecode(source));
  }

  @override
  String toString() {
    return 'CachedAccount('
        'id: $id, '
        'role: $role, '
        'displayName: $displayName, '
        'email: $email, '
        'password: ${password[0]}*****, '
        'avatarUrl: $avatarUrl, '
        'phone: $phone, '
        'gender: $gender, '
        'birthday: $birthday, '
        'lastSignIn: $lastSignIn, '
        'schoolId: $schoolId, '
        'ids: $ids'
        ')';
  }
}

class UserIds {
  final int? gradeId;
  final int? classId;
  final int? subjectId;
  final String? parentId;
  final String? studentId;

  const UserIds({
    this.gradeId,
    this.classId,
    this.subjectId,
    this.parentId,
    this.studentId,
  });

  factory UserIds.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const UserIds();

    return UserIds(
      gradeId: map['grade_id'],
      classId: map['class_id'],
      subjectId: map['subject_id'],
      parentId: map['parent_id'],
      studentId: map['student_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_id': gradeId,
      'class_id': classId,
      'subject_id': subjectId,
      'parent_id': parentId,
      'student_id': studentId,
    };
  }

  @override
  String toString() {
    return 'UserIds('
        'gradeId: $gradeId, '
        'classId: $classId, '
        'subjectId: $subjectId, '
        'parentId: $parentId, '
        'studentId: $studentId'
        ')';
  }
}
