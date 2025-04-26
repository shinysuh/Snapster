import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/constants/authorization.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/file/constants/file_content_type.dart';
import 'package:snapster_app/features/file/models/presigned_url_model.dart';
import 'package:snapster_app/features/file/models/uploaded_file_model.dart';

class FileService {
  static const _baseUrl = ApiInfo.fileBaseUrl;

  final TokenStorageService _tokenStorageService;

  FileService({TokenStorageService? tokenStorageService})
      : _tokenStorageService = tokenStorageService ?? TokenStorageService();

  // Pre-signed URL 발급
  Future<PresignedUrlModel?> fetchPresignedUrl(String fileName) async {
    try {
      final token = await _tokenStorageService.readToken();
      final uri = Uri.parse(
          '${ApiInfo.presignedBaseUrl}$fileName');
      final response = await http.get(
        uri,
        headers: {
          Authorizations.headerKey:
          '${Authorizations.headerValuePrefix} $token',
        },
      );

      if (response.statusCode == 200) {
        return PresignedUrlModel.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(
            'Pre-signed URL 요청 실패: ${response.statusCode} ${response.body}');
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
      final filePath = file.path;
      // 파일을 바이트로 읽어서 업로드
      final fileBytes = await File(filePath).readAsBytes();

      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {'Content-Type': _getContentTypeByFileExtension(filePath)},
        body: fileBytes,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('파일 업로드 실패: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('파일 업로드 중 오류 발생: $e');
      return false;
    }
  }

  Future<bool> saveUploadedFileInfo(UploadedFileModel uploadedFileInfo) async {
    final token = await _tokenStorageService.readToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: jsonEncode(uploadedFileInfo.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('파일 정보 저장 실패: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  String _getContentTypeByFileExtension(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return FileContentType.fromExtension(extension);
  }
}
