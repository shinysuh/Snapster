class VideoPostModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String videoId;
  final String videoUrl;
  final String thumbnailId;
  final String thumbnailUrl;
  final String userDisplayName;
  final String userId;
  final int likes;
  final int comments;
  final String createdAt;

  VideoPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.videoId,
    required this.videoUrl,
    required this.thumbnailId,
    required this.thumbnailUrl,
    required this.userDisplayName,
    required this.userId,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'videoId': videoId,
      'videoUrl': videoUrl,
      'thumbnailId': thumbnailId,
      'thumbnailUrl': thumbnailUrl,
      'userDisplayName': userDisplayName,
      'userId': userId,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  VideoPostModel.fromJson({
    String? videoId,
    required Map<String, dynamic> json,
  })  :
        // video_posts 에 저장된 id
        id = videoId ?? json['videoId'],
        title = json['title'],
        description = json['description'],
        tags = json['tags'],
        // uploaded_file 에 저장된 비디오 파일 id
        videoId = json['videoId'],
        videoUrl = json['videoUrl'],
        thumbnailId = json['thumbnailId'],
        thumbnailUrl = json['thumbnailUrl'],
        userDisplayName = json['userDisplayName'],
        userId = json['userId'],
        likes = json['likes'],
        comments = json['comments'],
        createdAt = json['createdAt'];

  VideoPostModel.sample({required this.id, required this.title})
      : description = '',
        tags = [],
        videoId = '0',
        videoUrl = '',
        thumbnailId = '0',
        thumbnailUrl = '',
        userDisplayName = '',
        userId = '',
        likes = 0,
        comments = 0,
        createdAt = '0';
}
