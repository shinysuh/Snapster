class VideoModel {
  final String id;
  final String title;
  final String description;
  final List<dynamic> tags;
  final String fileUrl;
  final String thumbnailURL;
  final String userDisplayName;
  final String userId;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.fileUrl,
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
      'fileUrl': fileUrl,
      'thumbnailURL': thumbnailURL,
      'uploader': userDisplayName,
      'uploaderUid': userId,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  VideoModel.fromJson({
    required String videoId,
    required Map<String, dynamic> json,
  })  : id = videoId,
        title = json['title'],
        description = json['description'],
        tags = json['tags'],
        fileUrl = json['fileUrl'],
        thumbnailURL = json['thumbnailURL'],
        userDisplayName = json['uploader'],
        userId = json['uploaderUid'],
        likes = json['likes'],
        comments = json['comments'],
        createdAt = json['createdAt'];

  VideoModel.sample({required this.id, required this.title})
      : description = '',
        tags = [],
        fileUrl = '',
        thumbnailURL = '',
        userDisplayName = '',
        userId = '',
        likes = 0,
        comments = 0,
        createdAt = 0;
}
