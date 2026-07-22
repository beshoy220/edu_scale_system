class UpdatedUserModel {
  final String id;
  final String role;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final String status;
  final String? gender;
  final DateTime? birthday;
  final DateTime createdAt;

  final int schoolId;
  final int? gradeId;
  final int? classId;
  final int? subjectId;

  final String? parentId;
  final String? studentId;

  const UpdatedUserModel({
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
    this.gradeId,
    this.classId,
    this.subjectId,
    this.parentId,
    this.studentId,
  });

  factory UpdatedUserModel.fromMap(Map<String, dynamic> map) {
    final profile = map['user_profiles'] as Map<String, dynamic>?;

    return UpdatedUserModel(
      id: map['id'] as String,
      schoolId: map['school_id'] as int,
      role: map['role'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatar_url'] as String?,
      phone: map['phone'] as String?,
      status: map['status'] as String,
      gender: map['gender'] as String?,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),

      gradeId: profile?['grade_id'] as int?,
      classId: profile?['class_id'] as int?,
      subjectId: profile?['subject_id'] as int?,
      parentId: profile?['parent_id'] as String?,
      studentId: profile?['student_id'] as String?,
    );
  }

  @override
  String toString() {
    return '''
UpdatedUserModel(
  id: $id,
  schoolId: $schoolId,
  role: $role,
  name: $name,
  email: $email,
  avatarUrl: $avatarUrl,
  phone: $phone,
  status: $status,
  gender: $gender,
  birthday: $birthday,
  createdAt: $createdAt,
  gradeId: $gradeId,
  classId: $classId,
  subjectId: $subjectId,
  parentId: $parentId,
  studentId: $studentId,
)
''';
  }
}
