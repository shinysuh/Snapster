import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class ChatroomParticipantModel {
  final ChatroomParticipantIdModel id;
  final AppUser user;
  DateTime? joinedAt;
  int? lastReadMessageId;
  DateTime? lastReadAt;

  ChatroomParticipantModel({
    required this.id,
    required this.user,
    this.joinedAt,
    this.lastReadMessageId,
    this.lastReadAt,
  });

  ChatroomParticipantModel.fromJson(Map<String, dynamic> json)
      : id = ChatroomParticipantIdModel.fromJson(json['id']),
        user = AppUser.fromJson(json['user']),
        joinedAt =
            json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : null,
        lastReadMessageId = json['lastReadMessageId'] ?? 0,
        lastReadAt = json['lastReadAt'] != null
            ? DateTime.parse(json['lastReadAt'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'user': user.toJson(),
      'joinedAt': joinedAt?.toIso8601String(),
      'lastReadMessageId': lastReadMessageId,
      'lastReadAt': lastReadAt?.toIso8601String(),
    };
  }

  ChatroomParticipantModel copyWith({
    ChatroomParticipantIdModel? id,
    AppUser? user,
    DateTime? joinedAt,
    int? lastReadMessageId,
    DateTime? lastReadAt,
  }) {
    return ChatroomParticipantModel(
      id: id ?? this.id,
      user: user ?? this.user,
      joinedAt: joinedAt ?? this.joinedAt,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
