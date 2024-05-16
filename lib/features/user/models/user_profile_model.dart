class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String link;
  final String birthday;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.link,
    required this.birthday,
  });

  UserProfileModel.empty()
      : uid = '',
        name = '',
        bio = '',
        email = '',
        link = '',
        birthday = '';

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        bio = json['bio'],
        email = json['email'],
        link = json['link'],
        birthday = json['birthday'];

  Map<String, String> toJson() {
    return {
      'uid': uid,
      'name': name,
      'bio': bio,
      'email': email,
      'link': link,
      'birthday': birthday,
    };
  }
}
