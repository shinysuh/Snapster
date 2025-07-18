import 'package:snapster_app/features/file/models/uploaded_file_model.dart';

class PresignedUrlModel {
  final String presignedUrl;
  final UploadedFileModel uploadedFileInfo;

  const PresignedUrlModel({
    required this.presignedUrl,
    required this.uploadedFileInfo,
  });

  PresignedUrlModel.fromJson(Map<String, dynamic> json)
      : presignedUrl = json['presignedUrl'],
        uploadedFileInfo = UploadedFileModel.fromJson(json['uploadedFileInfo']);
}
