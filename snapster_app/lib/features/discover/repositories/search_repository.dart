import 'package:snapster_app/features/discover/services/search_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';

class SearchRepository {
  final SearchService _searchService;

  SearchRepository(this._searchService);

  Future<List<VideoPostModel>> searchByKeywordPrefix(String keyword) async {
    return _searchService.searchByKeywordPrefix(keyword);
  }
}
