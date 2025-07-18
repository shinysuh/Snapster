class ThumbnailLinkModel {
  final String videoId;
  final String thumbnailUrl;
  final int createdAt;

  ThumbnailLinkModel({
    required this.videoId,
    required this.thumbnailUrl,
    required this.createdAt,
  });

  ThumbnailLinkModel.fromJson(Map<String, dynamic> json)
      : videoId = json['videoId'],
        thumbnailUrl = json['thumbnailUrl'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
    };
  }

  ThumbnailLinkModel copyWith({
    String? videoId,
    String? thumbnailUrl,
    int? createdAt,
  }) {
    return ThumbnailLinkModel(
      videoId: videoId ?? this.videoId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
