import 'package:snapster_app/features/file/models/uploaded_file_model.dart';
import 'package:snapster_app/features/file/models/video_post_model.dart';

class UploadedVideoModel {
  final VideoPostModel videoInfo;
  final UploadedFileModel uploadedFileInfo;

  UploadedVideoModel({
    required this.videoInfo,
    required this.uploadedFileInfo,
  });

  UploadedVideoModel.fromJson(Map<String, dynamic> json)
      : videoInfo = VideoPostModel.fromJson(json: json['videoInfo']),
        uploadedFileInfo = UploadedFileModel.fromJson(json['uploadedFileInfo']);

  Map<String, dynamic> toJson() => {
        "videoInfo": videoInfo.toJson(),
        "uploadedFileInfo": uploadedFileInfo.toJson(),
      };
}
