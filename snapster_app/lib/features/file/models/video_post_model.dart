class VideoPostModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String videoId;
  final String videoUrl;
  final String thumbnailId;
  final String thumbnailURL;
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
    required this.thumbnailURL,
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
      'thumbnailURL': thumbnailURL,
      'uploader': userDisplayName,
      'uploaderUid': userId,
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
        thumbnailURL = json['thumbnailURL'],
        userDisplayName = json['uploader'],
        userId = json['uploaderUid'],
        likes = json['likes'],
        comments = json['comments'],
        createdAt = json['createdAt'];

  VideoPostModel.sample({required this.id, required this.title})
      : description = '',
        tags = [],
        videoId = '0',
        videoUrl = '',
        thumbnailId = '0',
        thumbnailURL = '',
        userDisplayName = '',
        userId = '',
        likes = 0,
        comments = 0,
        createdAt = '0';
}
