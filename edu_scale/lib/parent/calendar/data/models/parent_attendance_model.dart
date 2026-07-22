class ParentAttendanceModel {
  final int id;
  final String takenBy;
  final String status;
  final String? reason;
  final DateTime createdAt;

  const ParentAttendanceModel({
    required this.id,
    required this.takenBy,
    required this.status,
    this.reason,
    required this.createdAt,
  });

  factory ParentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ParentAttendanceModel(
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

  ParentAttendanceModel copyWith({
    int? id,
    String? takenBy,
    String? status,
    String? reason,
    DateTime? createdAt,
  }) {
    return ParentAttendanceModel(
      id: id ?? this.id,
      takenBy: takenBy ?? this.takenBy,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ParentAttendanceModel(id: $id, takenBy: $takenBy, status: $status, reason: $reason, createdAt: $createdAt)';
}
