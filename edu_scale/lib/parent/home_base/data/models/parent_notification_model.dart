class ParentNotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;

  const ParentNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory ParentNotificationModel.fromMap(Map<String, dynamic> map) {
    return ParentNotificationModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ParentNotificationModel(id: $id, title: $title, body: $body, createdAt: $createdAt)';
  }
}
