import 'dart:io';

import 'package:snapster_app/features/file/models/presigned_url_model.dart';
import 'package:snapster_app/features/file/models/uploaded_file_model.dart';
import 'package:snapster_app/features/file/models/video_post_model.dart';
import 'package:snapster_app/features/file/services/file_service.dart';

class FileRepository {
  final FileService _fileService;

  FileRepository(this._fileService);

  Future<PresignedUrlModel?> getPresignedUrl(String fileName) async {
    return await _fileService.fetchPresignedUrl(fileName);
  }

  Future<bool> uploadFile(String presignedUrl, File file) async {
    return await _fileService.uploadFileToS3(presignedUrl, file);
  }

  Future<bool> saveUploadedFileInfo(UploadedFileModel fileInfo) async {
    return await _fileService.saveUploadedFileInfo(fileInfo);
  }

  Future<bool> saveVideoFileInfo(
    VideoPostModel videoInfo,
    UploadedFileModel uploadedFileInfo,
  ) async {
    return await _fileService.saveVideoFileInfo(videoInfo, uploadedFileInfo);
  }

  Future<bool> updateFileAsDeleted(UploadedFileModel fileInfo) async {
    return await _fileService.updateFileAsDeleted(fileInfo);
  }
}
