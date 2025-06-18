import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/authentication/views/sign_up/sign_up_screen.dart';
import 'package:snapster_app/features/chat/notification/models/fcm_token_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class FirebaseAuthenticationRepository implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    // return user == null ? null : AppUser.fromFirebaseUser(user);
    return user == null ? null : AppUser.empty();
  }

  @override
  bool get isLoggedIn => currentUser != null;

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
          (user) => user == null ? null : AppUser.empty(),
      // (user) => user == null ? null : AppUser.fromFirebaseUser(user),
    );
  }

  Future<UserCredential> firebaseSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<String> signUp(String email, String password) async {
    return '';
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut().then(
          (value) =>
          goToRouteNamedWithoutStack(
            context: context,
            routeName: SignUpScreen.routeName,
          ),
    );
  }

  Future<void> signInWithGithub() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }

  Future<void> signInWithApple() async {
    await _firebaseAuth.signInWithProvider(AppleAuthProvider());
  }

  Future<void> signInWithGoogle() async {
    await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
  }

  @override
  Future<void> checkLoginUser(BuildContext context) async {
    if (!isLoggedIn) {
      signOut(context);
      showSessionErrorSnack(context);
      throw Exception();
    }
  }

  @override
  Future<AppUser> getUserFromToken(String token) {
    // TODO: implement getUserFromToken
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFcmToken({required String accessToken, required FcmTokenModel fcm}) {
    // TODO: implement deleteFcmToken
    throw UnimplementedError();
  }

  @override
  Future<void> registerFcmToken(String accessToken, String fcmToken) {
    // TODO: implement registerFcmToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateFcmToken({required String accessToken, required String oldFcmToken, required String newFcmToken}) {
    // TODO: implement updateFcmToken
    throw UnimplementedError();
  }
}
