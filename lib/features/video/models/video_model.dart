class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailURL;
  final String uploader;
  final String uploaderUid;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.title,
    required this.description,
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
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'thumbnailURL': thumbnailURL,
      'uploader': uploader,
      'uploaderUid': uploaderUid,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  VideoModel.sample({required this.title})
      : description = '',
        fileUrl = '',
        thumbnailURL = '',
        uploader = '',
        uploaderUid = '',
        likes = 0,
        comments = 0,
        createdAt = 0;
}
