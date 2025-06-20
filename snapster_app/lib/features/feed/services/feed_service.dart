import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

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

    return handleListResponse<VideoPostModel>(
      response: response,
      fromJson: (e) => VideoPostModel.fromJson(json: e),
      errorPrefix: '사용자 피드 조회',
    );
  }
}
