import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';

class ChatroomParticipantModel {
  final ChatroomParticipantIdModel id;
  final int joinedAt;

  ChatroomParticipantModel({
    required this.id,
    required this.joinedAt,
  });

  ChatroomParticipantModel.fromJson(Map<String, dynamic> json)
      : id = ChatroomParticipantIdModel.fromJson(json['id']),
        joinedAt = json['joinedAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'joinedAt': joinedAt,
    };
  }

  ChatroomParticipantModel copyWith({
    ChatroomParticipantIdModel? id,
    int? joinedAt,
  }) {
    return ChatroomParticipantModel(
      id: id ?? this.id,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
