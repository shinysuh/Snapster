import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';

class ChatroomReadStatus {
  final ChatroomParticipantIdModel id;
  int? lastReadMessageId;
  int? lastReadAt;

  ChatroomReadStatus({
    required this.id,
    this.lastReadMessageId,
    this.lastReadAt,
  });

  ChatroomReadStatus.fromJson(Map<String, dynamic> json)
      : id = ChatroomParticipantIdModel.fromJson(json['id']),
        lastReadMessageId = json['lastReadMessageId'] ?? 0,
        lastReadAt = json['lastReadAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'lastReadMessageId': lastReadMessageId,
      'lastReadAt': lastReadAt,
    };
  }

  ChatroomReadStatus copyWith({
    ChatroomParticipantIdModel? id,
    int? lastReadMessageId,
    int? lastReadAt,
  }) {
    return ChatroomReadStatus(
      id: id ?? this.id,
      lastReadMessageId: lastReadMessageId ?? this.lastReadAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
