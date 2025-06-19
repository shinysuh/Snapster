class ChatMessageModel {
  final int id;
  final int chatroomId;
  final int senderId;
  final String content;
  final String type;
  final bool isDeleted;
  final String clientMessageId;
  final int createdAt;

  ChatMessageModel({
    required this.id,
    required this.chatroomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.isDeleted,
    required this.clientMessageId,
    required this.createdAt,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chatroomId = json['chatroomId'],
        senderId = json['senderId'],
        content = json['content'],
        type = json['type'],
        isDeleted = json['isDeleted'],
        clientMessageId = json['clientMessageId'],
        createdAt = json['createdAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatroomId': chatroomId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'isDeleted': isDeleted,
      'clientMessageId': clientMessageId,
      'createdAt': createdAt,
    };
  }

  ChatMessageModel copyWith({
    int? id,
    int? chatroomId,
    int? senderId,
    String? content,
    String? type,
    bool? isDeleted,
    String? clientMessageId,
    int? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      chatroomId: chatroomId ?? this.chatroomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      isDeleted: isDeleted ?? this.isDeleted,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
