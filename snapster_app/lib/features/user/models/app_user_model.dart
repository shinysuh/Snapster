import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  AppUser.fromJson(Map<String, dynamic> json)
      : uid = json['userId'].toString(),
        email = json['email'] ?? '',
        displayName = json['displayName'] ?? json['username'],
        photoUrl = json['photoUrl'];

  factory AppUser.fromFirebaseUser(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
