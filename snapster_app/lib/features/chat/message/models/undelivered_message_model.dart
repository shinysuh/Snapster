class UndeliveredMessageModel {
  final int id;
  final int chatroomId;
  final int senderId;
  final String content;
  final String type;

  UndeliveredMessageModel({
    required this.id,
    required this.chatroomId,
    required this.senderId,
    required this.content,
    required this.type,
  });

  UndeliveredMessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chatroomId = json['chatroomId'],
        senderId = json['senderId'],
        content = json['content'],
        type = json['type'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatroomId': chatroomId,
      'senderId': senderId,
      'content': content,
      'type': type,
    };
  }

  UndeliveredMessageModel copyWith({
    int? id,
    int? chatroomId,
    int? senderId,
    String? content,
    String? type,
  }) {
    return UndeliveredMessageModel(
      id: id ?? this.id,
      chatroomId: chatroomId ?? this.chatroomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
    );
  }
}
