class VideoPostModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String videoId;
  final String videoUrl;
  final String thumbnailId;
  final String thumbnailUrl;
  final String streamingId;
  final String streamingUrl;
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
    required this.streamingId,
    required this.streamingUrl,
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
      'streamingId': streamingId,
      'streamingUrl': streamingUrl,
      'userDisplayName': userDisplayName,
      'userId': userId,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  VideoPostModel.fromJson({
    required Map<String, dynamic> json,
  })  : id = json['id'].toString(),
        title = json['title'],
        description = json['description'],
        // null-safe 처리
        tags = (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        // uploaded_file 에 저장된 비디오 파일 id
        videoId = json['videoId'].toString(),
        videoUrl = json['videoUrl'],
        thumbnailId = json['thumbnailId'].toString(),
        thumbnailUrl = json['thumbnailUrl'],
        streamingId = json['streamingId'].toString(),
        streamingUrl = json['streamingUrl'],
        userDisplayName = json['userDisplayName'],
        userId = json['userId'].toString(),
        likes = json['likes'],
        comments = json['comments'],
        createdAt = json['createdAt'];

  VideoPostModel.sample({required this.id, required this.title})
      : description = '',
        tags = [],
        videoId = '',
        videoUrl = '',
        thumbnailId = '',
        thumbnailUrl = '',
        streamingId = '',
        streamingUrl = '',
        userDisplayName = '',
        userId = '',
        likes = 0,
        comments = 0,
        createdAt = '0';
}
