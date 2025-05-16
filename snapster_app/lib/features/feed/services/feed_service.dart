import 'package:flutter/cupertino.dart';
import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';

class FeedService {
  static const _userFeedBaseUrl = ApiInfo.userFeedBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  FeedService(this._tokenStorageService, this._dioService);

  Future<List<VideoPostModel>> fetchPublicUserFeeds(String userId) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_userFeedBaseUrl/public/$userId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => VideoPostModel.fromJson(json: e)).toList();
    } else {
      debugPrint('사용자 피드 조회 실패: ${response.statusCode} ${response.data}');
      return [];
    }
  }
}
