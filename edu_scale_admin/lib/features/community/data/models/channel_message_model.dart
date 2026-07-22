class ChannelMessageModel {
  final int id;
  final int channelId;
  final String senderId;
  final String senderName;
  final String senderRole;

  final int? attachedAssignmentId;
  final int? attachedQuizId;

  final String messageText;
  final DateTime createdAt;

  ChannelMessageModel({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.attachedAssignmentId,
    required this.attachedQuizId,
    required this.messageText,
    required this.createdAt,
  });

  factory ChannelMessageModel.fromJson(Map<String, dynamic> json) {
    return ChannelMessageModel(
      id: json['id'],
      channelId: json['channel_id'],
      senderId: json['sender_id']['id'],
      senderName: json['sender_id']['name'],
      senderRole: json['sender_id']['role'],
      attachedAssignmentId: json['attached_assignment_id'],
      attachedQuizId: json['attached_quiz_id'],
      messageText: json['message_text'] ?? '',
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'attached_assignment_id': attachedAssignmentId,
      'attached_quiz_id': attachedQuizId,
      'message_text': messageText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get hasAssignment => attachedAssignmentId != null;
  bool get hasQuiz => attachedQuizId != null;

  @override
  String toString() =>
      'ChannelMessageModel(id: $id, channelId: $channelId, senderId: $senderId, attachedAssignmentId: $attachedAssignmentId, attachedQuizId: $attachedQuizId, messageText: $messageText, createdAt: $createdAt)';
}
