import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

abstract class IAuthService {
  AppUser? get currentUser;

  bool get isLoggedIn;

  Stream<AppUser?> authStateChanges();

  // TODO - firebase 제거 시 삭제
  Future<UserCredential> firebaseSignUp(String email, String password);

  Future<String> signUp(String email, String password);

  Future<void> signIn(String email, String password);

  Future<void> signOut(BuildContext context);

  Future<String> signInWithKakao(String accessToken);

  Future<AppUser> getUserFromToken(String token);

  Future<void> signInWithGithub();

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  Future<void> checkLoginUser(BuildContext context);
}
