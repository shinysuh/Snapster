class CommentModel {
  final String videoId;
  String? commentId;
  final String text;
  final String userId;
  final String username;
  final int likes;
  final int createdAt;
  final int updatedAt;

  CommentModel({
    required this.videoId,
    this.commentId,
    required this.text,
    required this.userId,
    required this.username,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : videoId = json['videoId'],
        commentId = json['commentId'] ?? '',
        userId = json['userId'],
        username = json['username'],
        text = json['text'],
        likes = json['likes'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'text': text,
      'userId': userId,
      'username': username,
      'likes': likes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CommentModel copyWith({
    String? videoId,
    String? text,
    String? userId,
    String? username,
    int? likes,
    int? createdAt,
    int? updatedAt,
  }) {
    return CommentModel(
      videoId: videoId ?? this.videoId,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
