import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/authentication/views/sign_up/sign_up_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class FirebaseAuthenticationRepository implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AppUser.fromFirebaseUser(user);
  }

  @override
  bool get isLoggedIn => currentUser != null;

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
          (user) => user == null ? null : AppUser.fromFirebaseUser(user),
        );
  }

  @override
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
          (value) => goToRouteNamedWithoutStack(
            context: context,
            routeName: SignUpScreen.routeName,
          ),
        );
  }

  @override
  Future<void> signInWithGithub() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }

  @override
  Future<void> signInWithApple() async {
    await _firebaseAuth.signInWithProvider(AppleAuthProvider());
  }

  @override
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
  Future<String> signInWithKakao(String accessToken) {
    // TODO: implement signInWithKakao
    throw UnimplementedError();
  }
}
