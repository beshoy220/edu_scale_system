class TeacherAttendanceStudentModel {
  final String studentId;
  final String studentName;
  final String? avatarUrl;

  final int? attendanceId;
  final String? attendanceStatus;
  final String? attendanceReason;

  const TeacherAttendanceStudentModel({
    required this.studentId,
    required this.studentName,
    this.avatarUrl,
    this.attendanceId,
    this.attendanceStatus,
    this.attendanceReason,
  });

  factory TeacherAttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceStudentModel(
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      attendanceId: json['attendance_id'] as int?,
      attendanceStatus: json['attendance_status'] as String?,
      attendanceReason: json['attendance_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'avatar_url': avatarUrl,
      'attendance_id': attendanceId,
      'attendance_status': attendanceStatus,
      'attendance_reason': attendanceReason,
    };
  }

  TeacherAttendanceStudentModel copyWith({
    String? studentId,
    String? studentName,
    String? avatarUrl,
    int? attendanceId,
    String? attendanceStatus,
    String? attendanceReason,
  }) {
    return TeacherAttendanceStudentModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      attendanceId: attendanceId ?? this.attendanceId,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      attendanceReason: attendanceReason ?? this.attendanceReason,
    );
  }
}
