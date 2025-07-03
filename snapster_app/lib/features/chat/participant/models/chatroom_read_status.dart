import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';

class ChatroomReadStatus {
  final ChatroomParticipantIdModel id;
  int? lastReadMessageId;
  DateTime? lastReadAt;

  ChatroomReadStatus({
    required this.id,
    this.lastReadMessageId,
    this.lastReadAt,
  });

  ChatroomReadStatus.fromJson(Map<String, dynamic> json)
      : id = ChatroomParticipantIdModel.fromJson(json['id']),
        lastReadMessageId = json['lastReadMessageId'] ?? 0,
        lastReadAt = json['lastReadAt'] != null
            ? DateTime.parse(json['lastReadAt'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'lastReadMessageId': lastReadMessageId,
      'lastReadAt': lastReadAt?.toIso8601String(),
    };
  }

  ChatroomReadStatus copyWith({
    ChatroomParticipantIdModel? id,
    int? lastReadMessageId,
    DateTime? lastReadAt,
  }) {
    return ChatroomReadStatus(
      id: id ?? this.id,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
