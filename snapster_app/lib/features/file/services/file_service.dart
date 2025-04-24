import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/constants/authorization.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';

class FileService {
  final TokenStorageService _tokenStorageService;

  FileService({TokenStorageService? tokenStorageService})
      : _tokenStorageService = tokenStorageService ?? TokenStorageService();

  Future<String?> fetchPresignedUrl(String fileName) async {
    final token = await _tokenStorageService.readToken();

    final uri =
        Uri.parse('${ApiInfo.baseUrl}/api/s3/presigned-url?fileName=$fileName');
    final response = await http.get(
      uri,
      headers: {
        Authorizations.headerKey: '$Authorizations.headerValuePrefix $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body; // prep-signed url
    } else {
      debugPrint(
          'Pre-signed URL 요청 실패: ${response.statusCode} ${response.body}');
      return null;
    }
  }

  Future<bool> uploadFileToS3(String presignedUrl, String filePath) async {
    try {
      // 파일을 바이트로 읽어서 업로드
      final fileBytes = await File(filePath).readAsBytes();

      final response = await http.put(
        Uri.parse(presignedUrl),
        headers: {'Content-Type': 'application/octet-stream'},
        body: fileBytes,
      );

      if (response.statusCode == 200) {
        debugPrint('파일 업로드 성공');
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
}
