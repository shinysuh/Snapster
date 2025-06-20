import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';

class ChatroomModel {
  final int id;
  final int lastMessageId;
  final ChatMessageModel lastMessage;
  final List<ChatMessageModel> messages;
  final List<ChatroomParticipantModel> participants;
  final int createdAt;
  final int updatedAt;

  ChatroomModel({
    required this.id,
    required this.lastMessageId,
    required this.lastMessage,
    required this.messages,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatroomModel.empty()
      : id = 0,
        lastMessageId = 0,
        lastMessage = ChatMessageModel.empty(),
        messages = [],
        participants = [],
        createdAt = 0,
        updatedAt = 0;

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastMessageId = json['lastMessageId'] ?? 0,
        lastMessage = json['lastMessage'] != null
            ? ChatMessageModel.fromJson(json['lastMessage'])
            : ChatMessageModel.empty(),
        messages = json['messages'] != null
            ? (json['messages'] as List)
                .map((e) => ChatMessageModel.fromJson(e))
                .toList()
            : [],
        participants = json['participants'] != null
            ? (json['participants'] as List)
                .map((e) => ChatroomParticipantModel.fromJson(e))
                .toList()
            : [],
        createdAt = json['createdAt'] ?? 0,
        updatedAt = json['updatedAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastMessageId': lastMessageId,
      'lastMessage': lastMessage.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ChatroomModel copyWith({
    int? id,
    int? lastMessageId,
    ChatMessageModel? lastMessage,
    List<ChatMessageModel>? messages,
    List<ChatroomParticipantModel>? participants,
    int? createdAt,
    int? updatedAt,
  }) {
    return ChatroomModel(
      id: id ?? this.id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessage: lastMessage ?? this.lastMessage,
      messages: messages ?? this.messages,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
