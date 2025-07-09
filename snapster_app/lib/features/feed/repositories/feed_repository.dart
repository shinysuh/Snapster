import 'package:snapster_app/features/feed/services/feed_service.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';

class FeedRepository {
  final FeedService _feedService;

  FeedRepository(this._feedService);

  Future<List<VideoPostModel>> getPublicUserFeeds(String userId) {
    return _feedService.fetchPublicUserFeeds(userId);
  }

  Future<List<VideoPostModel>> getPrivateUserFeeds(String userId) {
    return _feedService.fetchPrivateUserFeeds(userId);
  }

  Future<bool> evictUserFeeds(String type, String userId) {
    return _feedService.evictUserFeeds(type, userId);
  }
}
