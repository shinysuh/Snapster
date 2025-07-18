class FcmTokenModel {
  final String userId;
  final String fcmToken;
  final String? oldToken;

  FcmTokenModel({
    required this.userId,
    required this.fcmToken,
    this.oldToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fcmToken': fcmToken,
      'oldToken': oldToken,
    };
  }

  FcmTokenModel.fromJson({
    required Map<String, dynamic> json,
  })  : userId = json['userId'].toString(),
        fcmToken = json['fcmToken'],
        oldToken = json['oldToken'] ?? '';
}
