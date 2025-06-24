import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

class HttpUserProfileService {
  static const _baseUrl = ApiInfo.userBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  HttpUserProfileService(this._tokenStorageService, this._dioService);

  Future<String?> _getToken() async {
    return await _tokenStorageService.readToken();
  }

  Future<List<AppUser>> getAllOtherUsers() async {
    final token = await _getToken();
    final response = await _dioService.get(
      uri: '$_baseUrl/others',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleListResponse<AppUser>(
      response: response,
      fromJson: (data) => AppUser.fromJson(data),
      errorPrefix: '사용자 목록 조회', // 로그인 사용자를 제외한 다른 모든 사용자 (채팅 목록)
    );
  }

  Future<void> updateUserProfile(AppUser updateUser) async {
    validateUpdateFields(updateUser);

    final token = await _getToken();

    final response = await _dioService.put(
      uri: '$_baseUrl/profile',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: updateUser,
    );

    if (response.statusCode == HttpStatus.ok) {
      debugPrint('사용자 정보 업데이트 성공');
    } else {
      debugPrint('사용자 정보 업데이트 실패: ${response.statusCode} ${response.data}');
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
