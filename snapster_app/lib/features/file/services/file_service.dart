import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/file/constants/file_content_type.dart';
import 'package:snapster_app/features/file/models/presigned_url_model.dart';
import 'package:snapster_app/features/file/models/uploaded_file_model.dart';
import 'package:snapster_app/features/file/models/uploaded_video_model.dart';
import 'package:snapster_app/features/file/models/video_post_model.dart';

class FileService {
  static const _baseUrl = ApiInfo.fileBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  FileService(this._tokenStorageService, this._dioService);

  // Pre-signed URL 발급
  Future<PresignedUrlModel?> fetchPresignedUrl(String fileName) async {
    try {
      final token = await _tokenStorageService.readToken();
      final uri = '${ApiInfo.presignedBaseUrl}$fileName';

      final response = await _dioService.get(
        uri: uri,
        headers: ApiInfo.getBasicHeaderWithToken(token),
      );

      if (response.statusCode == 200) {
        return PresignedUrlModel.fromJson(response.data);
      } else {
        debugPrint(
            'Pre-signed URL 요청 실패: ${response.statusCode} ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('Presigned URL 요청 중 오류 발생: $e');
      return null;
    }
  }

  // S3에 파일 업로드
  Future<bool> uploadFileToS3(String presignedUrl, File file) async {
    try {
      // final filePath = _normalizeExtension(file.path);
      final filePath = file.path;
      // 파일을 바이트로 읽어서 업로드
      final fileBytes = await File(filePath).readAsBytes();

      final response = await _dioService.filePut(
        uri: presignedUrl,
        headers: {'Content-Type': _getContentTypeByFileExtension(filePath)},
        body: fileBytes,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('파일 업로드 실패: ${response.statusCode} ${response.data}');
        return false;
      }
    } catch (e) {
      debugPrint('파일 업로드 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> saveUploadedFileInfo(UploadedFileModel fileInfo) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl/upload',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: fileInfo,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('파일 정보 저장 실패: ${response.statusCode} ${response.data}');
      return false;
    }
  }

  Future<bool> saveVideoFileInfo(
    VideoPostModel videoInfo,
    UploadedFileModel uploadedFileInfo,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
        uri: '$_baseUrl/video',
        headers: ApiInfo.getBasicHeaderWithToken(token),
        body: UploadedVideoModel(
          videoInfo: videoInfo,
          uploadedFileInfo: uploadedFileInfo,
        ));

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('비디오 파일 정보 저장 실패: ${response.statusCode} ${response.data}');
      return false;
    }
  }

  Future<bool> updateFileAsDeleted(UploadedFileModel fileInfo) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.put(
      uri: '$_baseUrl/delete',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: fileInfo.toJson(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('파일 정보 삭제 실패: ${response.statusCode} ${response.data}');
      return false;
    }
  }

  String _normalizeExtension(String path) {
    final extension = path.split('.').last.toLowerCase();
    if (extension == 'mov') {
      return path.replaceAll(RegExp(r'\.mov$', caseSensitive: false), '.mp4');
    }
    return path;
  }

  String _getContentTypeByFileExtension(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return FileContentType.fromExtension(extension);
  }
}
