class ChatMessageModel {
  final int id;
  final int chatroomId;
  final int senderId;
  final String senderDisplayName;
  int? receiverId;
  final String content;
  final String type;
  final bool isDeleted;
  final String clientMessageId;
  DateTime? createdAt;

  ChatMessageModel({
    required this.id,
    required this.chatroomId,
    required this.senderId,
    required this.senderDisplayName,
    this.receiverId,
    required this.content,
    required this.type,
    required this.isDeleted,
    required this.clientMessageId,
    this.createdAt,
  });

  bool isEmpty() {
    return id == 0 && chatroomId == 0 && senderId == 0;
  }

  ChatMessageModel.empty()
      : id = 0,
        chatroomId = 0,
        senderId = 0,
        senderDisplayName = '',
        content = '',
        type = '',
        clientMessageId = '',
        isDeleted = false;

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chatroomId = json['chatroomId'],
        senderId = json['senderId'],
        senderDisplayName = json['senderDisplayName'] ?? '',
        receiverId = json['receiverId'],
        content = json['content'],
        type = json['type'],
        isDeleted = json['isDeleted'],
        clientMessageId = json['clientMessageId'],
        createdAt = json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatroomId': chatroomId,
      'senderId': senderId,
      'senderDisplayName': senderDisplayName,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'isDeleted': isDeleted,
      'clientMessageId': clientMessageId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  ChatMessageModel copyWith({
    int? id,
    int? chatroomId,
    int? senderId,
    String? senderDisplayName,
    int? receiverId,
    String? content,
    String? type,
    bool? isDeleted,
    String? clientMessageId,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      chatroomId: chatroomId ?? this.chatroomId,
      senderId: senderId ?? this.senderId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      isDeleted: isDeleted ?? this.isDeleted,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
