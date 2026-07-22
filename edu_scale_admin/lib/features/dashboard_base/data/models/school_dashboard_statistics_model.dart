class SchoolDashboardStatisticsModel {
  final UserStatistics users;
  final SchoolStatistics schoolStatistics;

  SchoolDashboardStatisticsModel({
    required this.users,
    required this.schoolStatistics,
  });

  factory SchoolDashboardStatisticsModel.fromJson(Map<String, dynamic> json) {
    return SchoolDashboardStatisticsModel(
      users: UserStatistics.fromJson(json['users'] ?? {}),
      schoolStatistics: SchoolStatistics.fromJson(
        json['school_statistics'] ?? {},
      ),
    );
  }

  @override
  String toString() =>
      'SchoolDashboardStatisticsModel(users: $users, schoolStatistics: $schoolStatistics)';
}

class UserStatistics {
  final UserRoleStatistics students;
  final UserRoleStatistics parents;
  final UserRoleStatistics admins;
  final TeacherStatistics teachers;

  UserStatistics({
    required this.students,
    required this.parents,
    required this.admins,
    required this.teachers,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      students: UserRoleStatistics.fromJson(json['students'] ?? {}),
      parents: UserRoleStatistics.fromJson(json['parents'] ?? {}),
      admins: UserRoleStatistics.fromJson(json['admins'] ?? {}),
      teachers: TeacherStatistics.fromJson(json['teachers'] ?? {}),
    );
  }

  @override
  String toString() =>
      'UserStatistics(students: $students, parents: $parents, admins: $admins, teachers: $teachers)';
}

class UserRoleStatistics {
  final int total;
  final int active;
  final int pending;
  final int suspended;

  UserRoleStatistics({
    required this.total,
    required this.active,
    required this.pending,
    required this.suspended,
  });

  factory UserRoleStatistics.fromJson(Map<String, dynamic> json) {
    return UserRoleStatistics(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      pending: json['pending'] ?? 0,
      suspended: json['suspended'] ?? 0,
    );
  }

  @override
  String toString() =>
      'UserRoleStatistics(total: $total, active: $active, pending: $pending, suspended: $suspended)';
}

class TeacherStatistics extends UserRoleStatistics {
  final Map<String, int> teacherCountBySubjects;

  TeacherStatistics({
    required super.total,
    required super.active,
    required super.pending,
    required super.suspended,
    required this.teacherCountBySubjects,
  });

  factory TeacherStatistics.fromJson(Map<String, dynamic> json) {
    final rawSubjects = Map<String, dynamic>.from(
      json['teacher_count_by_subjects'] ?? {},
    );

    return TeacherStatistics(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      pending: json['pending'] ?? 0,
      suspended: json['suspended'] ?? 0,
      teacherCountBySubjects: rawSubjects.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
    );
  }

  @override
  String toString() =>
      'TeacherStatistics(total: $total, active: $active, pending: $pending, suspended: $suspended, teacherCountBySubjects: $teacherCountBySubjects)';
}

class SchoolStatistics {
  final int quizzesCount;
  final int assignmentsCount;
  final int libraryResourcesCount;
  final int competitionsCount;
  final int classesCount;

  SchoolStatistics({
    required this.quizzesCount,
    required this.assignmentsCount,
    required this.libraryResourcesCount,
    required this.competitionsCount,
    required this.classesCount,
  });

  factory SchoolStatistics.fromJson(Map<String, dynamic> json) {
    return SchoolStatistics(
      quizzesCount: json['quizzes_count'] ?? 0,
      assignmentsCount: json['assignments_count'] ?? 0,
      libraryResourcesCount: json['library_resources_count'] ?? 0,
      competitionsCount: json['competitions_count'] ?? 0,
      classesCount: json['classes_count'] ?? 0,
    );
  }

  @override
  String toString() =>
      'SchoolStatistics(quizzesCount: $quizzesCount, assignmentsCount: $assignmentsCount, libraryResourcesCount: $libraryResourcesCount, competitionsCount: $competitionsCount, classesCount: $classesCount)';
}
