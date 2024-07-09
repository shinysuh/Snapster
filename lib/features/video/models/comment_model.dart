class CommentModel {
  final String videoId;
  String? commentId;
  final String text;
  final String userId;
  final int createdAt;
  final int updatedAt;

  CommentModel({
    required this.videoId,
    this.commentId,
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : videoId = json['videoId'],
        commentId = json['commentId'] ?? '',
        userId = json['userId'],
        text = json['text'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'text': text,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CommentModel copyWith({
    String? videoId,
    String? text,
    String? userId,
    int? createdAt,
    int? updatedAt,
  }) {
    return CommentModel(
      videoId: videoId ?? this.videoId,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
