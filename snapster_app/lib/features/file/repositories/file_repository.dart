import 'dart:io';

import 'package:snapster_app/features/file/services/file_service.dart';

class FileRepository {
  final FileService _fileService;

  FileRepository(this._fileService);

  Future<String?> getPresignedUrl(String fileName) async {
    return await _fileService.fetchPresignedUrl(fileName);
  }

  Future<bool> uploadFile(String presignedUrl, File file) async {
    return await _fileService.uploadFileToS3(presignedUrl, file);
  }
}
