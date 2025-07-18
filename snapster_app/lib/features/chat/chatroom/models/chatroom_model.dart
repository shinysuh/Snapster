import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';

class ChatroomModel {
  final int id;
  final ChatMessageModel lastMessage;
  final List<ChatroomParticipantModel> participants;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatroomModel({
    required this.id,
    required this.lastMessage,
    required this.participants,
    this.createdAt,
    this.updatedAt,
  });

  bool isEmpty() {
    return id == 0 && participants.isEmpty && lastMessage.isEmpty();
  }

  ChatroomModel.empty()
      : id = 0,
        lastMessage = ChatMessageModel.empty(),
        participants = [];

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastMessage = json['lastMessage'] != null
            ? ChatMessageModel.fromJson(json['lastMessage'])
            : ChatMessageModel.empty(),
        participants = json['participants'] != null
            ? (json['participants'] as List)
                .map((e) => ChatroomParticipantModel.fromJson(e))
                .toList()
            : [],
        createdAt = json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt = json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastMessage': lastMessage.toJson(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ChatroomModel copyWith({
    int? id,
    ChatMessageModel? lastMessage,
    List<ChatroomParticipantModel>? participants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatroomModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
