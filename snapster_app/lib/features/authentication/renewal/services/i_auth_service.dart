import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/chat/notification/models/fcm_token_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

abstract class IAuthService {
  AppUser? get currentUser;

  bool get isLoggedIn;

  Stream<AppUser?> authStateChanges();

  Future<String> signUp(String email, String password);

  Future<void> signIn(String email, String password);

  Future<void> signOut(BuildContext context);

  Future<AppUser> getUserFromToken(String token);

  Future<void> checkLoginUser(BuildContext context);

  Future<void> registerFcmToken(String accessToken, String fcmToken);

  Future<void> updateFcmToken({
    required String accessToken,
    required String oldFcmToken,
    required String newFcmToken,
  });

  Future<void> deleteFcmToken({
    required String accessToken,
    required FcmTokenModel fcm,
  });
}
