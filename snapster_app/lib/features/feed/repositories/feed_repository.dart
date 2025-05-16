import 'package:snapster_app/features/feed/services/feed_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';

class FeedRepository {
  final FeedService _feedService;

  FeedRepository(this._feedService);

  Future<List<VideoPostModel>> getPublicUserFeeds(String userId) {
    return _feedService.fetchPublicUserFeeds(userId);
  }
}
