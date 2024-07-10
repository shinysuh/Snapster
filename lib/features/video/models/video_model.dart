class VideoModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String fileUrl;
  final String thumbnailURL;
  final String uploader;
  final String uploaderUid;
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
    required this.uploader,
    required this.uploaderUid,
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
      'uploader': uploader,
      'uploaderUid': uploaderUid,
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
        uploader = json['uploader'],
        uploaderUid = json['uploaderUid'],
        likes = json['likes'],
        comments = json['comments'],
        createdAt = json['createdAt'];

  VideoModel.sample({required this.id, required this.title})
      : description = '',
        tags = [],
        fileUrl = '',
        thumbnailURL = '',
        uploader = '',
        uploaderUid = '',
        likes = 0,
        comments = 0,
        createdAt = 0;
}
