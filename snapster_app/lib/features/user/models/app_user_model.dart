import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String userId;
  final String email;
  final String? username;
  final String? profileImageUrl;

  final String? name;
  final String? bio;
  final String? link;
  final String? birthday;
  final bool? hasProfileImage;

  const AppUser({
    required this.userId,
    required this.email,
    this.username,
    this.profileImageUrl,
    this.name,
    this.bio,
    this.link,
    this.birthday,
    this.hasProfileImage,
  });

  AppUser.fromJson(Map<String, dynamic> json)
      : userId = json['userId'].toString(),
        email = json['email'] ?? '',
        username = json['username'],
        profileImageUrl = json['profileImageUrl'],
        name = json['name'],
        bio = json['bio'],
        link = json['link'],
        birthday = json['birthday'],
        hasProfileImage = json['hasProfileImage'];

  factory AppUser.fromFirebaseUser(User firebaseUser) {
    return AppUser(
      userId: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      username: firebaseUser.displayName,
      profileImageUrl: firebaseUser.photoURL,
    );
  }
}
