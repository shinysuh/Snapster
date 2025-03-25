import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/views/sign_up_screen.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get user => _firebaseAuth.currentUser;

  bool get isLoggedIn => user != null;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut().then(
          (value) => goToRouteNamedWithoutStack(
            context: context,
            routeName: SignUpScreen.routeName,
          ),
        );
  }

  Future<void> githubSingIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }

  Future<void> appleSingIn() async {
    await _firebaseAuth.signInWithProvider(AppleAuthProvider());
  }

  Future<void> googleSingIn() async {
    await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
  }

  Future<void> checkLoginUser(BuildContext context) async {
    if (!isLoggedIn) {
      signOut(context);
      showSessionErrorSnack(context);
      throw Exception();
    }
  }
}

final authRepository = Provider(
  (ref) => AuthenticationRepository(),
);

final authState = StreamProvider((ref) {
  final repository = ref.read(authRepository);
  return repository.authStateChanges();
});
