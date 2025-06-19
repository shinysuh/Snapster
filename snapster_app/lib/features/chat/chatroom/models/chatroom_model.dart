class ChatroomModel {
  final int id;
  final int lastMessageId;
  final int createdAt;
  final int updatedAt;

  ChatroomModel({
    required this.id,
    required this.lastMessageId,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastMessageId = json['lastMessageId'] ?? 0,
        createdAt = json['createdAt'] ?? 0,
        updatedAt = json['updatedAt'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastMessageId': lastMessageId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ChatroomModel copyWith({
    int? id,
    int? lastMessageId,
    int? createdAt,
    int? updatedAt,
  }) {
    return ChatroomModel(
      id: id ?? this.id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
