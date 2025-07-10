import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

class SearchService {
  static const _searchBaseUrl = ApiInfo.searchBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  SearchService(this._tokenStorageService, this._dioService);

  Future<List<VideoPostModel>> searchByKeywordPrefix(String keyword) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_searchBaseUrl/prefix?keyword=$keyword',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleListResponse<VideoPostModel>(
      response: response,
      fromJson: (e) => VideoPostModel.fromJson(json: e),
      errorPrefix: '[$keyword] 검색 결과 조회',
    );
  }
}
