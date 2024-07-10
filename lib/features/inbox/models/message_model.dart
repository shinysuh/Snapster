class MessageModel {
  final String text;
  final String userId;
  final int createdAt;
  String? textId;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
    this.textId,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        userId = json['userId'],
        createdAt = json['createdAt'],
        textId = json['textId'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'createdAt': createdAt,
      'textId': textId ?? '',
    };
  }

  MessageModel copyWith({
    String? text,
    String? userId,
    int? createdAt,
  }) {
    return MessageModel(
      text: text ?? this.text,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
