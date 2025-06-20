import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';

class ChatroomParticipantModel {
  final ChatroomParticipantIdModel id;
  int? joinedAt;
  int? lastReadMessageId;
  int? lastReadAt;

  ChatroomParticipantModel({
    required this.id,
    this.joinedAt,
    this.lastReadMessageId,
    this.lastReadAt,
  });

  ChatroomParticipantModel.fromJson(Map<String, dynamic> json)
      : id = ChatroomParticipantIdModel.fromJson(json['id']),
        joinedAt = json['joinedAt'] ?? 0,
        lastReadMessageId = json['lastReadMessageId'] ?? 0,
        lastReadAt = json['lastReadAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'joinedAt': joinedAt,
      'lastReadMessageId': lastReadMessageId,
      'lastReadAt': lastReadAt,
    };
  }

  ChatroomParticipantModel copyWith({
    ChatroomParticipantIdModel? id,
    int? joinedAt,
    int? lastReadMessageId,
    int? lastReadAt,
  }) {
    return ChatroomParticipantModel(
      id: id ?? this.id,
      joinedAt: joinedAt ?? this.joinedAt,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
