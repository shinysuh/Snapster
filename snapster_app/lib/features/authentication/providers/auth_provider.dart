import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/repositories/firebase_authentication_repository.dart';

// TODO - 제거 예정
final firebaseAuthServiceProvider = Provider(
  (ref) => FirebaseAuthenticationRepository(),
);

// TODO - 제거 예정
// final authState = StreamProvider((ref) {
//   final repository = ref.read(firebaseAuthServiceProvider);
//   return repository.authStateChanges();
// });
