class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String link;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : uid = '',
        name = '',
        bio = '',
        email = '',
        link = '';

  Map<String, String> toJson() {
    return {
      'uid': uid,
      'name': name,
      'bio': bio,
      'email': email,
      'link': link,
    };
  }
}
