class UploadedFileModel {
  final String? fileId;
  final String userId;
  final String fileName;
  final String s3FilePath;
  final String url;
  final String? type;
  final bool? isPrivate;
  final bool? isDeleted;
  final String? uploadedAt;

  const UploadedFileModel({
    this.fileId,
    required this.userId,
    required this.fileName,
    required this.s3FilePath,
    required this.url,
    this.type,
    this.isPrivate,
    this.isDeleted,
    this.uploadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': int.parse(userId), // userId가 String이므로 변환
      'fileName': fileName,
      's3FilePath': s3FilePath,
      'url': url,
      'type': type ?? '',
      'isPrivate': isPrivate ?? false, // null일 경우 false 처리
    };
  }

  UploadedFileModel.fromJson(Map<String, dynamic> json)
      : fileId = json['fileId'].toString(),
        userId = json['userId'].toString(),
        fileName = json['fileName'],
        s3FilePath = json['s3FilePath'],
        url = json['url'],
        type = json['type'],
        isPrivate = json['isPrivate'],
        isDeleted = json['isDeleted'],
        uploadedAt = json['uploadedAt'];

  UploadedFileModel copyWith({
    String? userId,
    String? fileName,
    String? s3FilePath,
    String? url,
    String? type,
  }) {
    return UploadedFileModel(
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      s3FilePath: s3FilePath ?? this.s3FilePath,
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }
}
