import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class HttpUserProfileService {
  static const _baseUrl = ApiInfo.userBaseUrl;

  final TokenStorageService _tokenStorageService;

  HttpUserProfileService({TokenStorageService? tokenStorageService})
      : _tokenStorageService = tokenStorageService ?? TokenStorageService();

  Future<String?> _getToken() async {
    return await _tokenStorageService.readToken();
  }

  Future<void> updateUserProfile(AppUser updateUser) async {
    validateUpdateFields(updateUser);

    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/profile');

    final res = await http.put(
      uri,
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: jsonEncode(updateUser),
    );

    if (res.statusCode == 200) {
      debugPrint('사용자 정보 업데이트 성공');
    } else {
      debugPrint('사용자 정보 업데이트 실패: ${res.statusCode} ${res.body}');
    }
  }

  void validateUpdateFields(AppUser updateUser) {
    if (updateUser.username.isEmpty) {
      throw Exception('Username cannot be empty');
    }
    if (updateUser.displayName.isEmpty) {
      throw Exception('Nickname cannot be empty');
    }
  }
}
