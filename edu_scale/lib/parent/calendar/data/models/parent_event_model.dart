class ParentEventModel {
  final int id;
  final int schoolId;
  final String title;
  final String description;
  final DateTime dayDate;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final List<EventTargetModel> targets;

  ParentEventModel({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.dayDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.targets,
  });

  factory ParentEventModel.fromJson(Map<String, dynamic> json) {
    return ParentEventModel(
      id: json['id'],
      schoolId: json['school_id'],
      title: json['title'],
      description: json['description'],
      dayDate: DateTime.parse(json['day_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdAt: DateTime.parse(json['created_at']),
      targets: (json['event_targets'] as List<dynamic>? ?? [])
          .map((e) => EventTargetModel.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ParentEventModel(id: $id, schoolId: $schoolId, title: $title, description: $description, dayDate: $dayDate, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, targets: $targets)';
  }
}

class EventTargetModel {
  final int id;
  final int? gradeId;
  final int? classId;
  final int? subjectId;
  final String? role;

  EventTargetModel({
    required this.id,
    required this.gradeId,
    required this.classId,
    required this.subjectId,
    required this.role,
  });

  factory EventTargetModel.fromJson(Map<String, dynamic> json) {
    return EventTargetModel(
      id: json['id'],
      gradeId: json['grade_id'] ?? 0,
      classId: json['class_id'] ?? 0,
      subjectId: json['subject_id'] ?? 0,
      role: json['role'] ?? 'All',
    );
  }

  @override
  String toString() {
    return 'EventTargetModel(id: $id, gradeId: $gradeId, classId: $classId, subjectId: $subjectId, role: $role)';
  }
}
