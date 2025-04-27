import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/providers/token_storage_provider.dart';
import 'package:snapster_app/features/user/repository/http_user_profile_repository.dart';
import 'package:snapster_app/features/user/services/http_user_profile_service.dart';

final userProfileServiceProvider = Provider<HttpUserProfileService>(
  (ref) => HttpUserProfileService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final userProfileRepositoryProvider = Provider<HttpUserProfileRepository>(
  (ref) {
    final userProfileService = ref.read(userProfileServiceProvider);
    return HttpUserProfileRepository(userProfileService);
  },
);
