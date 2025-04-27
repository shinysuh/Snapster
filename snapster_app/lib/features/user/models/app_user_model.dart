import 'package:snapster_app/utils/text_util.dart';

class AppUser {
  final String userId;
  final String username;
  final String email;
  final String profileImageUrl;
  final String displayName;
  final String bio;
  final String link;
  final String birthday;
  final bool hasProfileImage;

  const AppUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.displayName,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.hasProfileImage,
  });

  AppUser.empty()
      : userId = '',
        username = '',
        email = '',
        profileImageUrl = '',
        displayName = '',
        bio = '',
        link = '',
        birthday = '',
        hasProfileImage = false;

  AppUser.fromJson(Map<String, dynamic> json)
      : userId = json['userId'].toString(),
        username = json['username'] ?? '',
        email = json['email'] ?? '',
        profileImageUrl = json['profileImageUrl'] ?? '',
        displayName = json['displayName'] ?? '',
        bio = json['bio'],
        link = json['link'],
        birthday = json['birthday'] ?? '',
        hasProfileImage = json['hasProfileImage'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'displayName': displayName,
      'bio': escapeSpecialCharacters(bio),
      'link': escapeSpecialCharacters(link),
      'birthday': birthday,
      'hasProfileImage': hasProfileImage,
    };
  }

  AppUser copyWith({
    String? email,
    String? profileImageUrl,
    String? displayName,
    String? bio,
    String? link,
    String? birthday,
    bool? hasProfileImage,
  }) {
    return AppUser(
      userId: userId,
      username: username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      hasProfileImage: hasProfileImage ?? this.hasProfileImage,
    );
  }
}
