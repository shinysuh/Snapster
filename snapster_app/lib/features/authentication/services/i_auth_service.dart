import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
}
