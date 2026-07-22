class ClassStatisticsModel {
  final AttendanceByDay attendanceByDay;
  final List<AssignmentBySubject> assignmentsBySubject;
  final List<QuizBySubject> quizzesBySubject;
  final int assignmentSubmissionsCount;
  final int quizSubmissionsCount;
  final List<StudentStatisticsModel> students;

  ClassStatisticsModel({
    required this.attendanceByDay,
    required this.assignmentsBySubject,
    required this.quizzesBySubject,
    required this.assignmentSubmissionsCount,
    required this.quizSubmissionsCount,
    required this.students,
  });

  factory ClassStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ClassStatisticsModel(
      attendanceByDay: AttendanceByDay.fromJson(
        json['attendance_by_day'] ?? {},
      ),

      assignmentsBySubject:
          (json['assignments_by_subject'] as List<dynamic>? ?? [])
              .map((e) => AssignmentBySubject.fromJson(e))
              .toList(),

      quizzesBySubject: (json['quizzes_by_subject'] as List<dynamic>? ?? [])
          .map((e) => QuizBySubject.fromJson(e))
          .toList(),

      assignmentSubmissionsCount: json['assignment_submissions_count'] ?? 0,

      quizSubmissionsCount: json['quiz_submissions_count'] ?? 0,

      students: (json['students'] as List<dynamic>? ?? [])
          .map((e) => StudentStatisticsModel.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ClassStatisticsModel(attendanceByDay: $attendanceByDay, assignmentsBySubject: $assignmentsBySubject, quizzesBySubject: $quizzesBySubject, assignmentSubmissionsCount: $assignmentSubmissionsCount, quizSubmissionsCount: $quizSubmissionsCount, students: $students)';
  }
}

class AttendanceByDay {
  final AttendanceDayStatistics mon;
  final AttendanceDayStatistics tue;
  final AttendanceDayStatistics wed;
  final AttendanceDayStatistics thu;
  final AttendanceDayStatistics fri;
  final AttendanceDayStatistics sat;
  final AttendanceDayStatistics sun;

  AttendanceByDay({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  factory AttendanceByDay.fromJson(Map<String, dynamic> json) {
    return AttendanceByDay(
      mon: AttendanceDayStatistics.fromJson(json['mon'] ?? {}),
      tue: AttendanceDayStatistics.fromJson(json['tue'] ?? {}),
      wed: AttendanceDayStatistics.fromJson(json['wed'] ?? {}),
      thu: AttendanceDayStatistics.fromJson(json['thu'] ?? {}),
      fri: AttendanceDayStatistics.fromJson(json['fri'] ?? {}),
      sat: AttendanceDayStatistics.fromJson(json['sat'] ?? {}),
      sun: AttendanceDayStatistics.fromJson(json['sun'] ?? {}),
    );
  }

  @override
  String toString() =>
      'AttendanceByDay(mon: $mon, tue: $tue, wed: $wed, thu: $thu, fri: $fri, sat: $sat, sun: $sun)';
}

class AttendanceDayStatistics {
  final int present;
  final int absent;
  final int late;
  final int excused;

  AttendanceDayStatistics({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  factory AttendanceDayStatistics.fromJson(Map<String, dynamic> json) {
    return AttendanceDayStatistics(
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      excused: json['excused'] ?? 0,
    );
  }

  @override
  String toString() =>
      'AttendanceDayStatistics(present: $present, absent: $absent, late: $late, excused: $excused)';
}

class AssignmentBySubject {
  final String subjectName;
  final String teacherName;
  final int assignmentMadeCount;

  AssignmentBySubject({
    required this.subjectName,
    required this.teacherName,
    required this.assignmentMadeCount,
  });

  factory AssignmentBySubject.fromJson(Map<String, dynamic> json) {
    return AssignmentBySubject(
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      assignmentMadeCount: json['assignment_made_count'] ?? 0,
    );
  }

  @override
  String toString() =>
      'AssignmentBySubject(subjectName: $subjectName, teacherName: $teacherName, assignmentMadeCount: $assignmentMadeCount)';
}

class QuizBySubject {
  final String subjectName;
  final String teacherName;
  final int quizzesMadeCount;

  QuizBySubject({
    required this.subjectName,
    required this.teacherName,
    required this.quizzesMadeCount,
  });

  factory QuizBySubject.fromJson(Map<String, dynamic> json) {
    return QuizBySubject(
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      quizzesMadeCount: json['quizzes_made_count'] ?? 0,
    );
  }

  @override
  String toString() =>
      'QuizBySubject(subjectName: $subjectName, teacherName: $teacherName, quizzesMadeCount: $quizzesMadeCount)';
}

class StudentStatisticsModel {
  final String studentId;
  final String studentName;
  final String avatarUrl;

  StudentStatisticsModel({
    required this.studentId,
    required this.studentName,
    required this.avatarUrl,
  });

  factory StudentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return StudentStatisticsModel(
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }
  @override
  String toString() =>
      'StudentStatisticsModel(studentId: $studentId, studentName: $studentName, avatarUrl: $avatarUrl)';
}
