class ParentChannelMessageModel {
  final int id;
  final int channelId;
  final ChannelMessageSenderModel sender;
  final int? attachedAssignmentId;
  final int? attachedQuizId;
  final String messageText;
  final DateTime createdAt;

  const ParentChannelMessageModel({
    required this.id,
    required this.channelId,
    required this.sender,
    this.attachedAssignmentId,
    this.attachedQuizId,
    required this.messageText,
    required this.createdAt,
  });

  factory ParentChannelMessageModel.fromJson(Map<String, dynamic> json) {
    return ParentChannelMessageModel(
      id: json['id'] as int,
      channelId: json['channel_id'] as int,
      sender: ChannelMessageSenderModel.fromJson(
        json['users'] as Map<String, dynamic>,
      ),
      attachedAssignmentId: json['attached_assignment_id'] as int?,
      attachedQuizId: json['attached_quiz_id'] as int?,
      messageText: json['message_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'users': sender.toJson(),
      'attached_assignment_id': attachedAssignmentId,
      'attached_quiz_id': attachedQuizId,
      'message_text': messageText,
      'created_at': createdAt.toLocal().toIso8601String(),
    };
  }

  ParentChannelMessageModel copyWith({
    int? id,
    int? channelId,
    ChannelMessageSenderModel? sender,
    int? attachedAssignmentId,
    int? attachedQuizId,
    String? messageText,
    DateTime? createdAt,
  }) {
    return ParentChannelMessageModel(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      sender: sender ?? this.sender,
      attachedAssignmentId: attachedAssignmentId ?? this.attachedAssignmentId,
      attachedQuizId: attachedQuizId ?? this.attachedQuizId,
      messageText: messageText ?? this.messageText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ParentChannelMessageModel(id: $id, channelId: $channelId, sender: $sender, messageText: $messageText)';
  }
}

class ChannelMessageSenderModel {
  final String name;
  final String role;

  const ChannelMessageSenderModel({required this.name, required this.role});

  factory ChannelMessageSenderModel.fromJson(Map<String, dynamic> json) {
    return ChannelMessageSenderModel(
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role};
  }

  ChannelMessageSenderModel copyWith({String? name, String? role}) {
    return ChannelMessageSenderModel(
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'ChannelMessageSenderModel(name: $name, role: $role)';
  }
}
