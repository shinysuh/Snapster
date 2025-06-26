import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';

class ChatroomModel {
  final int id;
  final ChatMessageModel lastMessage;
  final List<ChatMessageModel> messages; // 채팅방 입장 후 세팅
  final List<ChatroomParticipantModel> participants;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatroomModel({
    required this.id,
    required this.lastMessage,
    required this.messages,
    required this.participants,
    this.createdAt,
    this.updatedAt,
  });

  ChatroomModel.empty()
      : id = 0,
        lastMessage = ChatMessageModel.empty(),
        messages = [],
        participants = [];

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
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
      'messages': messages.map((e) => e.toJson()).toList(),
      'participants': participants.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ChatroomModel copyWith({
    int? id,
    ChatMessageModel? lastMessage,
    List<ChatMessageModel>? messages,
    List<ChatroomParticipantModel>? participants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatroomModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      messages: messages ?? this.messages,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
