class UserProfileModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String link;
  final String birthday;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.hasAvatar,
  });

  UserProfileModel.empty()
      : uid = '',
        name = '',
        username = '',
        bio = '',
        email = '',
        link = '',
        birthday = '',
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        username = json['username'],
        bio = json['bio'],
        email = json['email'],
        link = json['link'],
        birthday = json['birthday'],
        hasAvatar = json['hasAvatar'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'bio': bio,
      'email': email,
      'link': link,
      'birthday': birthday,
      'hasAvatar': hasAvatar,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? bio,
    String? link,
    String? birthday,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
