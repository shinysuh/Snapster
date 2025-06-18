import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/chat/notification/services/fcm_token_storage_service.dart';

class FcmTokenUtil {
  final IAuthService _authService;
  final FcmTokenStorageService _fcmStorageService;
  bool _isListening = false;

  FcmTokenUtil(this._authService, this._fcmStorageService);

  Future<void> listenFcmTokenRefresh(String accessToken) async {
    if (_isListening) return; // 중복 리스닝 방지

    _isListening = true;

    FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) async {
      final oldFcmToken = await _fcmStorageService.readFcmToken();

      if (accessToken.isNotEmpty &&
          oldFcmToken != null &&
          oldFcmToken != newFcmToken) {
        await _authService.updateFcmToken(
          accessToken: accessToken,
          oldFcmToken: oldFcmToken,
          newFcmToken: newFcmToken,
        );
        await storeFcmToken(newFcmToken);
      }
    });
  }

  Future<String?> generateFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<String?> readFcmToken() async {
    return await _fcmStorageService.readFcmToken();
  }

  Future<void> storeFcmToken(String fcmToken) async {
    await _fcmStorageService.saveFcmToken(fcmToken);
  }

  Future<void> deleteFcmToken() async {
    await _fcmStorageService.deleteFcmToken();
  }
}
