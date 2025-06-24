import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/feed/repositories/feed_repository.dart';
import 'package:snapster_app/features/feed/services/feed_service.dart';

final feedServiceProvider = Provider<FeedService>(
  (ref) => FeedService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => FeedRepository(ref.read(feedServiceProvider)),
);
