import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/providers/http_auth_provider.dart';
import 'package:snapster_app/features/chat/notification/services/fcm_token_storage_service.dart';
import 'package:snapster_app/features/chat/notification/utils/fcm_token_util.dart';

final fcmTokenStorageProvider = Provider<FcmTokenStorageService>(
  (ref) => FcmTokenStorageService(),
);

final fcmTokenUtilProvider = Provider<FcmTokenUtil>((ref) {
  return FcmTokenUtil(
    ref.read(httpAuthServiceProvider),
    ref.read(fcmTokenStorageProvider),
  );
});
