class StudentAttendanceModel {
  final int id;
  final String takenBy;
  final String status;
  final String? reason;
  final DateTime createdAt;

  const StudentAttendanceModel({
    required this.id,
    required this.takenBy,
    required this.status,
    this.reason,
    required this.createdAt,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'] as int,
      takenBy: json['taken_by'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taken_by': takenBy,
      'status': status,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  StudentAttendanceModel copyWith({
    int? id,
    String? takenBy,
    String? status,
    String? reason,
    DateTime? createdAt,
  }) {
    return StudentAttendanceModel(
      id: id ?? this.id,
      takenBy: takenBy ?? this.takenBy,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'StudentAttendanceModel(id: $id, takenBy: $takenBy, status: $status, reason: $reason, createdAt: $createdAt)';
}
